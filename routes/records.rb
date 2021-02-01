require_relative '../entities/record'

class Kurpelwoodworks
  hash_branch 'records' do |r|
    r.is do
      r.get do
        @record = Record.new
        view("records/form")
      end

      r.post do
        @record = Record.new
        save_record(r)

        if @new_record
          r.redirect "/records/#{@record.id}"
        else
          view("records/form")
        end
      end
    end

    r.on Integer do |id|
      r.is do
        @record = Record.with_pk!(id)

        r.get do
          view("records/form")
        end

        r.post do
          @record
          save_record(r)
          view("records/form")
        end
      end
    end
  end

  private

  def save_record(r)
    begin
      @record.set_fields(r.params['record'], %w'name description').save
      @new_record = true
    rescue Sequel::ValidationFailed => message
      @errors = message.errors
    end
  end
end
