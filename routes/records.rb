require_relative '../entities/record'

class Kurpelwoodworks
  hash_branch 'records' do |r|
    # route[records_create]: GET|POST /records
    r.is do
      @record = Record.new
      load_record_tags_var

      r.get do
        view("records/form")
      end

      r.post do
        save_record(r)

        if @new_record
          r.redirect "/records/#{@record.id}"
        else
          view("records/form")
        end
      end
    end

    # route[records_view_edit]: GET|POST /records/:record_id
    r.on Integer do |id|
      r.is do
        @record = Record.eager(:tags).with_pk!(id)

        r.get do
          load_record_tags_var
          view("records/form")
        end

        r.post do
          save_record(r)
          load_record_tags_var
          view("records/form")
        end
      end
    end

    # route[records_search]: GET|POST /records/search
    r.is 'search' do
      r.get do
        view("records/search_form")
      end

      r.post String do |search_term|
        binding.pry
      end
    end

    # route[records_index]: GET /records/index
    r.on 'index' do
      r.get do
        @pagy, @records = pagy(Record)
        view("records/index")
      end
    end
  end

  private

  def save_record(r)
    begin
      DB.transaction do
        @record.set_fields(r.params['record'], %w'name description').save

        if r.params['record'].include? '_tags'
          @record.tags.map(&:delete)

          record_tags = r.params['record']['_tags'].split(',')
          record_tags = record_tags.uniq.map(&:strip)

          record_tags.each do |tag_name|
            tag = Tag.find_or_create(name: tag_name)
            @record.add_tag(tag) if tag && !@record.tags.include?(tag)
          end

          #NOTE: reload @record to load new tags in ui
          @record.reload
        end
        @new_record = true
      end
    rescue Sequel::ValidationFailed => message
      @errors = message.errors
    end
  end

  def load_record_tags_var
    @record_tags = []

    if @record.tags.any?
      @record_tags = @record.tags.collect(&:name)
      @hidden_record_tags = @record_tags.join(',')
    end
  end
end
