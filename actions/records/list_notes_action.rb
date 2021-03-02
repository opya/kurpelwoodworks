require 'pagy'
require 'lib/action'
require 'repositories/note_repository'
require 'presenters/notes_presenter'

module Kurpelwoodworks
  class ListNotesAction < Action
    include Pagy::Backend

    NOTES_PER_PAGE = 5 

    result :notes, :paginator

    def self.build
      new(repository: NoteRepository, presenter: NotesPresenter)
    end

    def initialize(repository:, presenter:)
      @repository = repository
      @presenter = presenter
    end

    def perform(page)
      repo = @repository.build
      pagy = Pagy.new({count: repo.count, page: page, items: NOTES_PER_PAGE})
      data = repo.paginete(offset: pagy.offset, limit: NOTES_PER_PAGE)

      result.success(notes: @presenter.call(data), paginator: pagy)
    end
  end
end
