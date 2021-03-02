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
      new(repository: NoteRepository.build)
    end

    def initialize(repository:)
      @repository = repository
    end

    def perform(page)
      pagy = Pagy.new({count: @repository.count, page: page, items: NOTES_PER_PAGE})
      data = @repository.paginete(offset: pagy.offset, limit: NOTES_PER_PAGE)

      result.success(notes: NotesPresenter.call(data), paginator: pagy)
    end
  end
end
