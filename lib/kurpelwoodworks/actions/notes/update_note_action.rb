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

        def perform(id, name, description)
          validator = validation.call(name: name, description: description)

          if validator.success?
            note = repository.update!(id: id, input: validator.values.data)

            if note
              result.success(note: presenter.call(note))
            else
              result.failure(tr('note.generic.not_found'))
            end
          elsif validator.failure?
            result.failure(validator.errors.to_h)
          end
        end

      end
    end
  end
end
