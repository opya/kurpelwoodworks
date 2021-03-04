require 'kurpelwoodworks/lib/translate'
require 'kurpelwoodworks/lib/action'

module Kurpelwoodworks
  module Actions
    module Notes
      class UpdateNoteAction < Action

        include Translate
        include Import[
          repository: 'repositories.note_repository',
          presenter: 'presenters.note_presenter',
          validation: 'validations.note_validation'
        ]

        result :note

        def perform(input)
          validator = validation.call(input)

          if validator.success?
            note = repository.update!(validator.to_h)

            if note
              result.success(note: presenter.call(note))
            else
              result.failure(tr('note.generic.not_found'))
            end
          else
            result.failure(validator.errors.to_h)
          end
        end

      end
    end
  end
end
