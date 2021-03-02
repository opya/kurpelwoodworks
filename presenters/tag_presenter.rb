require 'lib/presenter'

class TagPresenter
  def call(object)
    {
      name: object.name
    }
  end
end
