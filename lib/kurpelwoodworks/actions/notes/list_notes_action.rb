require 'pagy'
require 'kurpelwoodworks/lib/action'

module Kurpelwoodworks
  module Actions
    module Notes
      class ListNotesAction < Action
        include Import[
          repository: 'repositories.note_repository',
          presenter: 'presenters.notes_presenter'
        ]
        include Pagy::Backend

        NOTES_PER_PAGE = 5 

        result :notes, :paginator

        def perform(page)
          repo = repository
          pagy = Pagy.new({count: repo.count, page: page, items: NOTES_PER_PAGE})
          data = repo.paginete(offset: pagy.offset, limit: NOTES_PER_PAGE)

          result.success(notes: presenter.call(data), paginator: pagy)
        end
      end
    end
  end
end
