require 'lib/translate'
require 'lib/action'
require 'repositories/note_repository'
require 'validations/note_validation'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class UpdateNoteAction < Action
    include Translate

    result :note

    def perform(id, name, description)
      validator = NoteValidation.new.call(name: name, description: description)

      if validator.success?
        note = NoteRepository.new.update!(id: id, input: validator.values.data)

        if note
          result.success(note: NotePresenter.call(note))
        else
          result.failure(tr('note.generic.not_found'))
        end
      elsif validator.failure?
        result.failure(validator.errors.to_h)
      end
    end

  end
end
