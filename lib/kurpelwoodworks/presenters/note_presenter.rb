require 'kurpelwoodworks/presenters/tag_presenter'

module Kurpelwoodworks
  module Presenters
    class NotePresenter
      def call(object)
        {
          id: object.id,
          name: object.name,
          description: object.description,
          tags: object.tags.map{ |tag| TagPresenter.call(tag) }
        }
      end
    end
  end
end
