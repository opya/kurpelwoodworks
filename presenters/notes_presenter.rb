require 'lib/presenter'
require 'presenters/note_presenter'

module Kurpelwoodworks
  class NotesPresenter < Presenter
    def call
      @object.map { |record| NotePresenter.call(record) }
    end
  end
end
