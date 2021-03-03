require 'kurpelwoodworks/lib/presenter'

module Kurpelwoodworks
  module Presenters
    class TagPresenter
      def call(object)
        {
          name: object.name
        }
      end
    end
  end
end
