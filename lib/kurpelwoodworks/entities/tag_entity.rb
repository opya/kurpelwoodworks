module Kurpelwoodworks
  module Entities
    class TagEntity
      attr_reader :id, :name, :created_at, :updated_at

      def initialize(id:, name:, created_at:, updated_at:, **args)
        @id = id
        @name = name
        @created_at = created_at
        @updated_at = updated_at
      end

    end
  end
end
