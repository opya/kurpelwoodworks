require 'kurpelwoodworks/lib/translate'

module Kurpelwoodworks
  module Actions
    module Notes
      class ShowNoteAction
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:perform)
        include Translate
        include Import[
          repository: "repositories.note_repository",
          presenter: "presenters.note_presenter"
        ]

        def perform(note_id)
          note = repository.find_by_id(note_id)

          if note
            Success(note: presenter.call(note))
          else
            Failure(errors: [tr('note.generic.not_found')])
          end
        end

      end
    end
  end
end
