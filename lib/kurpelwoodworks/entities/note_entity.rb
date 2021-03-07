module Kurpelwoodworks
  module Entities
    class NoteEntity
      attr_reader :id, :name, :description, :tags, :created_at, :updated_at

      def initialize(id:, name:, description:, created_at:, updated_at:, tags: [], **args)
        @id = id
        @name = name
        @description = description
        @tags = tags
        @created_at = created_at
        @updated_at = updated_at
      end

      def tags=(tags)
        @tags = tags
      end
    end
  end
end
