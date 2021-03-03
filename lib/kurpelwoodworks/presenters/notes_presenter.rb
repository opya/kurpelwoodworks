require 'kurpelwoodworks/lib/presenter'
require 'kurpelwoodworks/presenters/note_presenter'

module Kurpelwoodworks
  module Presenters
    class NotesPresenter
      def call(object)
        object.map { |record| NotePresenter.new.call(record) }
      end
    end
  end
end
