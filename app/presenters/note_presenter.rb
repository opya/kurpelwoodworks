require 'lib/presenter'
require 'presenters/tag_presenter'

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
