require 'pry'

module Kurpelwoodworks
  module Repositories
    class NoteRepository
      include Import[
        'models.note_model',
        tags_repo: 'repositories.tag_repository'
      ]

      def find_by_id(id, tags: false)
        if tags
          note = model.eager(:tags)[id]

          if note && note.tags.any?
            note_tags = note.tags.map{|t| tags_repo.send(:to_entity, t)}
            note = to_entity(note)
            note.tags = note_tags

            note
          end
        else
          note = model[id]
          note ? to_entity(note) : nil
        end
      end

      def create!(input)
        note = model.new(input).save
        to_entity(note)
      end

      def create_with_tags!(input)
        tags_input = input.delete(:tags) if input.has_key? :tags

        note = create!(input)

        if note && tags_input

          tags_input.each do |tag_name|
            tag = tags_repo.find_or_create_by_name!(tag_name)
            model[note.id].add_tag(tag.id)

            note.tags << tag
          end
          
        end

        note
      end

      def update!(input)
        note = model[input.delete(:id)]

        if note
          note.update(input)
          to_entity(note)
        end
      end

      def paginate(offset, limit)
        model.offset(offset).limit(limit).map{|n| to_entity(n)}
      end

      def count
        model.count
      end

      private

      def model
        note_model.model
      end

      def to_entity(attributes)
        Entities::NoteEntity.new(**attributes)
      end
    end
  end
end
