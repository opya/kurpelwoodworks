module Kurpelwoodworks
  class NoteEntity
    attr_reader :id, :name, :description, :tags

    def initialize(id:, name:, description:, tags: [])
      @id = id
      @name = name
      @description = description
      @tags = tags
    end
  end
end
