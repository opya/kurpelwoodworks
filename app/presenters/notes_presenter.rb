require 'lib/presenter'
require 'presenters/note_presenter'

class NotesPresenter
  def call(object)
    object.map { |record| NotePresenter.new.call(record) }
  end
end
