require 'kurpelwoodworks/entities/note_entity'

module Kurpelwoodworks
  module Repositories
    class NoteRepository
      include Import['models.note_model']

      def find(id:)
        note = model.find(id: id) 
        to_entity(note) if note
      end

      def create!(name:, description:)
        to_entity(
          model.new(
            name: name,
            description: description
          ).save
        )
      end

      def update!(id:, input:)
        note = model.find(id: id)

        if note
          note.update(input)
          to_entity(note)
        end
      end

      def paginete(offset:, limit:)
        notes = model.offset(offset).limit(limit).map do |note|
          to_entity(note)
        end

        notes
      end

      def count
        model.count
      end

      def model
        note_model.model
      end

      private

      def to_entity(attributes)
        NoteEntity.new(**attributes)
      end
    end
  end
end
