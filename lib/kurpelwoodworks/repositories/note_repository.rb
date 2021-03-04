require 'kurpelwoodworks/entities/note_entity'

module Kurpelwoodworks
  module Repositories
    class NoteRepository
      include Import['models.note_model']

      def find(id:)
        note = model.find(id: id) 
        note ? to_entity(note) : nil
      end

      def create!(input:)
        note = model.new(input).save
        note ? to_entity(note) : nil
      end

      def update!(id:, input:)
        note = model.find(id: id)
        note ? to_entity(note.update(input)) : nil
      end

      def paginate(offset:, limit:)
        notes = model.offset(offset).limit(limit).map do |note|
          to_entity(note)
        end

        notes
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
