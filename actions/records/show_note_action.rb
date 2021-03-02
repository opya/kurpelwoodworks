require 'lib/action'
require 'repositories/note_repository'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class ShowNoteAction < Action
    result :note

    def self.build
      new(repository: NoteRepository, presenter: NotePresenter)
    end

    def initialize(repository:, presenter:)
      @repository = repository
      @presenter = presenter
    end

    def perform(note_id)
      note = @repository.build.find(id: note_id)

      if note
        result.success(note: @presenter.call(note))
      else
        result.failure(tr('note.generic.not_found'))
      end
    end
  end
end
