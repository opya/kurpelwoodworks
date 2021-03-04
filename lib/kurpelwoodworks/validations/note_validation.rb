require 'kurpelwoodworks/lib/validation'

module Kurpelwoodworks
  module Validations
    class NoteValidation < Validation
      config.messages.top_namespace = :note

      params do
        optional(:id).filled(:integer)
        required(:name).filled(:string)
        required(:description).filled(:string)
        optional(:tags).value(:array)
      end

      rule(:name) do
        key.failure(:too_short) if value.length < 10
        key.failure(:too_long) if value.length > 150
      end

      rule(:description) do
        key.failure(:too_short) if value.length < 20
      end
    end
  end
end
