require 'lib/presenter'

module Kurpelwoodworks
  class TagPresenter < Presenter
    def call
      {
        name: @object.name
      }
    end
  end
end
