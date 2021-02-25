require_relative './presenter.rb'
require_relative './tag_presenter.rb'

class RecordPresenter < Presenter
  def call
    {
      id: @object.id,
      name: @object.name,
      description: @object.description,
      tags: @object.tags.map{ |tag| TagPresenter.call(tag) }
    }
  end
end
