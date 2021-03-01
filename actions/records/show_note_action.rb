require 'lib/action'
require 'repositories/note_repository'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class ShowNoteAction < Action
    result :note

    def perform(note_id)
      note = NoteRepository.new.find(id: note_id)

      if note
        result.success(note: NotePresenter.call(note))
      else
        result.failure(tr('note.generic.not_found'))
      end
    end
  end
end
