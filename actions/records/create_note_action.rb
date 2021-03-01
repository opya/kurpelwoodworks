require 'lib/action'
require 'repositories/note_repository'
require 'validations/note_validation'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class CreateNoteAction < Action
    result :note

    def perform(name, description)
      validator = NoteValidation.new.call(
        name: name,
        description: description)

      if validator.success?
        note = NoteRepository.new.create!(name: name, description: description)
        result.success(note: NotePresenter.call(note))
      elsif validator.failure?
        result.failure(validator.errors.to_h)
      end
    end

  end
end
