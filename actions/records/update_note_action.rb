require 'lib/translate'
require 'lib/action'
require 'repositories/note_repository'
require 'validations/note_validation'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class UpdateNoteAction < Action
    include Translate

    result :note

    def self.build
      new(repository: NoteRepository, presenter: NotePresenter, validator: NoteValidation)
    end

    def initialize(repository:, presenter:, validator:)
      @repository = repository
      @presenter = presenter
      @validator = validator
    end

    def perform(id, name, description)
      validator = @validator.new.call(name: name, description: description)

      if validator.success?
        note = @repository.build.update!(id: id, input: validator.values.data)

        if note
          result.success(note: @presenter.call(note))
        else
          result.failure(tr('note.generic.not_found'))
        end
      elsif validator.failure?
        result.failure(validator.errors.to_h)
      end
    end

  end
end
