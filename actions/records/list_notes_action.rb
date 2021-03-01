require 'pagy'

require 'lib/action'
require 'repositories/note_repository'
require 'presenters/notes_presenter'

module Kurpelwoodworks
  class ListNotesAction < Action
    include Pagy::Backend

    NOTES_PER_PAGE = 5 

    result :notes, :paginator

    def perform(page)
      note_repo = NoteRepository.new

      pagy = Pagy.new({count: note_repo.count, page: page, items: NOTES_PER_PAGE})
      data = note_repo.paginete(offset: pagy.offset, limit: NOTES_PER_PAGE)

      result.success(notes: NotesPresenter.call(data), paginator: pagy)
    end
  end
end
