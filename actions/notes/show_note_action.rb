require 'lib/action'

module Notes
  class ShowNoteAction < Action
    include Import[
      repository: "note_repository",
      presenter: "note_presenter"
    ]

    result :note

    def perform(note_id)
      note = repository.find(id: note_id)

      if note
        result.success(note: presenter.call(note))
      else
        result.failure(tr('note.generic.not_found'))
      end
    end
  end
end
