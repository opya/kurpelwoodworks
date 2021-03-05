module Kurpelwoodworks
  module Actions
    module Notes
      class CreateNoteAction
        include Dry::Monads[:result]
        include Dry::Monads::Do.for(:perform)
        include Import[
          repository: 'repositories.note_repository',
          presenter: 'presenters.note_presenter',
          validation: 'validations.note_validation'
        ]

        def perform(input)
          input_values = yield validate(input)
          persist(input_values)
        end

        private

        def validate(input)
          v = validation.call(input)
          v.success? ? Success(v.values.to_h) : Failure(errors: v.errors.to_h)
        end

        def persist(input)
          note = repository.create!(input)
          Success(note: presenter.call(note))
        end
      end
    end
  end
end
