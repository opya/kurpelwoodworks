require 'lib/action'

module Notes
  class CreateNoteAction < Action
    include Import[
      repository: 'note_repository',
      presenter: 'note_presenter',
      validation: 'note_validation'
    ]

    result :note

    def perform(name, description)
      validator = validation.call(
        name: name,
        description: description)

      if validator.success?
        note = repository.build.create!(name: name, description: description)
        result.success(note: presenter.call(note))
      else
        result.failure(validator.errors.to_h)
      end
    end

  end
end
