require 'lib/presenter'
require 'presenters/tag_presenter'

module Kurpelwoodworks
  class NotePresenter < Presenter
    def call
      {
        id: @object.id,
        name: @object.name,
        description: @object.description,
        tags: @object.tags.map{ |tag| TagPresenter.call(tag) }
      }
    end
  end
end
