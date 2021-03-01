require 'records/note_record'
require 'models/note_model'

module Kurpelwoodworks
  class NoteRepository
    def find(id:)
      note = NoteRecord.find(id: id) 
      to_model(note) if note
    end

    def create!(name:, description:)
      to_model(
        NoteRecord.new(
          name: name,
          description: description
        ).save
      )
    end

    def update!(id:, input:)
      note = NoteRecord.find(id: id)

      if note
        note.update(input)
        to_model(note)
      end
    end

    def paginete(offset:, limit:)
      notes = NoteRecord.offset(offset).limit(limit).map do |note|
        to_model(note.values)
      end

      notes
    end

    def count
      NoteRecord.count
    end


    private

    def to_model(attributes)
      NoteModel.new(**attributes)
    end
  end
end
