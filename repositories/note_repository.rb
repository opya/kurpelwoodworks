require 'records/note_record'
require 'models/note_model'

module Kurpelwoodworks
  class NoteRepository
    def self.build
      new(record: NoteRecord, model: NoteModel)
    end

    def initialize(record:, model:)
      @record = record
      @model = model
    end

    def find(id:)
      note = @record.find(id: id) 
      to_model(note) if note
    end

    def create!(name:, description:)
      to_model(
        @record.new(
          name: name,
          description: description
        ).save
      )
    end

    def update!(id:, input:)
      note = @record.find(id: id)

      if note
        note.update(input)
        to_model(note)
      end
    end

    def paginete(offset:, limit:)
      notes = @record.offset(offset).limit(limit).map do |note|
        to_model(note.values)
      end

      notes
    end

    def count
      @record.count
    end

    private

    def to_model(attributes)
      @model.new(**attributes)
    end
  end
end
