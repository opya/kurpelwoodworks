require 'pagy'
require 'kurpelwoodworks/lib/action'
require 'kurpelwoodworks/lib/validation'

module Kurpelwoodworks
  module Actions
    module Notes
      class ListNotesAction < Action
        class NoteListActionValidation < Validation
          config.messages.top_namespace = :note_list_action

          params do
            required(:page).filled(:integer)
          end
        end

        include Import[
          repository: 'repositories.note_repository',
          presenter: 'presenters.notes_presenter'
        ]
        include Pagy::Backend

        NOTES_PER_PAGE = 5 

        result :notes, :paginator

        def perform(page)
          validator = NoteListActionValidation.new.call(page: page)

          if validator.success?
            repo = repository
            pagy = Pagy.new({count: repo.count, page: page, items: NOTES_PER_PAGE})
            data = repo.paginate(offset: pagy.offset, limit: NOTES_PER_PAGE)

            result.success(notes: presenter.call(data), paginator: pagy)
          else
            result.failure(validator.errors.to_h)
          end
        end
      end
    end
  end
end
