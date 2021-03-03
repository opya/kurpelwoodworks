require 'lib/translate'
require 'lib/action'

module Notes
  class UpdateNoteAction < Action

    include Translate
    include Import[
      repository: 'note_repository',
      presenter: 'note_presenter',
      validation: 'note_validation'
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
