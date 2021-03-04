require 'kurpelwoodworks/lib/action'
require 'kurpelwoodworks/lib/translate'

module Kurpelwoodworks
  module Actions
    module Notes
      class ShowNoteAction < Action
        include Translate
        include Import[
          repository: "repositories.note_repository",
          presenter: "presenters.note_presenter"
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
  end
end
