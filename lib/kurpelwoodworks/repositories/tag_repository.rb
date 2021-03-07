module Kurpelwoodworks
  module Repositories
    class TagRepository
      include Import['models.tag_model']

      def create!(input)
        tag = model.new(input).save
        to_entity(tag)
      end

      def find_by_name(input)
        tag = model[name: input]
        tag ? to_entity(tag) : nil
      end

      def find_or_create_by_name!(input)
        tag = model.find_or_create(name: input)
        to_entity(tag)
      end

      private

      def model
        tag_model.model
      end

      def to_entity(attributes)
        Entities::TagEntity.new(**attributes)
      end
    end
  end
end
