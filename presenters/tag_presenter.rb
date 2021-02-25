require_relative './presenter.rb'

class TagPresenter < Presenter
  def call
    {
      name: @object.name
    }
  end
end
