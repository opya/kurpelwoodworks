require 'pagy'
require 'kurpelwoodworks/lib/validation'
require 'kurpelwoodworks/lib/translate'

module Kurpelwoodworks
  module Actions
    module Notes
      class ListNotesAction
        include Translate
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:perform)

        class NoteListActionValidation < Validation
          config.messages.top_namespace = :note_list_action

          params do
            required(:page).filled(:integer)
          end

          rule(:page) do
            key.failure(:page_is_less_or_eq_zero) if value <= 0
          end
        end

        include Import[
          repository: 'repositories.note_repository',
          presenter: 'presenters.notes_presenter'
        ]

        include Pagy::Backend

        NOTES_PER_PAGE = 5 

        def perform(page)
          input_values= yield validate(page)
          list(input_values)
        end

        private

        def validate(input)
          v = NoteListActionValidation.new.call(page: input)
          v.success? ? Success(v.values.to_h) : Failure(errors: v.errors.to_h)
        end

        def list(page)
          repo = repository

          begin
            pagy = Pagy.new({count: repo.count, page: page[:page], items: NOTES_PER_PAGE})
            data = repo.paginate(pagy.offset, NOTES_PER_PAGE)

            Success(notes: presenter.call(data), paginator: pagy)
          rescue Pagy::OverflowError
            Failure(errors: [tr('note_list_action.generic.no_records_for_page')])
          end
        end

      end
    end
  end
end
