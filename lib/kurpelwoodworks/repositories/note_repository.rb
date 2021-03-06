require 'kurpelwoodworks/entities/note_entity'

module Kurpelwoodworks
  module Repositories
    class NoteRepository
      include Import['models.note_model']

      def find_by_id(id)
        note = model[id]
        note ? to_entity(note) : nil
      end

      def create!(input)
        note = model.new(input).save
        to_entity(note)
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
