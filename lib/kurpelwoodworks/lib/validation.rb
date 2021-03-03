require 'dry-validation'

module Kurpelwoodworks
  class Validation < Dry::Validation::Contract
    config.messages.backend = :i18n
  end
end
