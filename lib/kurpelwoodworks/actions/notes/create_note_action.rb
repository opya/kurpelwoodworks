require 'kurpelwoodworks/lib/action'

module Kurpelwoodworks
  module Actions
    module Notes
      class CreateNoteAction < Action
        include Import[
          repository: 'repositories.note_repository',
          presenter: 'presenters.note_presenter',
          validation: 'validations.note_validation'
        ]

        result :note

        def perform(input)
          validator = validation.call(input)

          if validator.success?
            note = repository.create!(input: validator.to_h)
            result.success(note: presenter.call(note))
          else
            result.failure(validator.errors.to_h)
          end
        end

      end
    end
  end
end
