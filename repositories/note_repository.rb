require 'models/note_model'

class NoteRepository
  include Import[record: 'note_record']

  def find(id:)
    note = record.model.find(id: id) 
    to_model(note) if note
  end

  def create!(name:, description:)
    to_model(
      record.model.new(
        name: name,
        description: description
      ).save
    )
  end

  def update!(id:, input:)
    note = find(id: id)

    if note
      note.update(input)
      to_model(note)
    end
  end

  def paginete(offset:, limit:)
    notes = record.model.offset(offset).limit(limit).map do |note|
      to_model(note.values)
    end

    notes
  end

  def count
    record.model.count
  end

  private

  def to_model(attributes)
    NoteModel.new(**attributes)
  end
end
