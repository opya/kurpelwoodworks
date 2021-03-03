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

        def perform(name, description)
          validator = validation.call(
            name: name,
            description: description)

          if validator.success?
            note = repository.create!(name: name, description: description)
            result.success(note: presenter.call(note))
          else
            result.failure(validator.errors.to_h)
          end
        end

      end
    end
  end
end
