require 'dry-validation'

class Validation < Dry::Validation::Contract
  config.messages.backend = :i18n
end
