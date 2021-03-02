require 'lib/action'
require 'repositories/note_repository'
require 'validations/note_validation'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class CreateNoteAction < Action
    result :note

    def self.build
      new(repository: NoteRepository, presenter: NotePresenter, validator: NoteValidation)
    end

    def initialize(repository:, presenter:, validator:)
      @repository = repository
      @presenter = presenter
      @validator = validator
    end

    def perform(name, description)
      validator = @validator.new.call(
        name: name,
        description: description)

      if validator.success?
        note = @repository.build.create!(name: name, description: description)
        result.success(note: @presenter.call(note))
      else
        result.failure(validator.errors.to_h)
      end
    end

  end
end
