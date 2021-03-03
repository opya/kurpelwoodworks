require 'entities/note_entity'

class NoteRepository
  include Import[note_model: 'note_model']

  def find(id:)
    note = note_model.model.find(id: id) 
    to_entity(note) if note
  end

  def create!(name:, description:)
    to_entity(
      note_model.model.new(
        name: name,
        description: description
      ).save
    )
  end

  def update!(id:, input:)
    note = find(id: id)

    if note
      note.update(input)
      to_entity(note)
    end
  end

  def paginete(offset:, limit:)
    notes = note_model.model.offset(offset).limit(limit).map do |note|
      to_entity(note.values)
    end

    notes
  end

  def count
    note_model.model.count
  end

  private

  def to_entity(attributes)
    NoteEntity.new(**attributes)
  end
end
