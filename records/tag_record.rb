module Kurpelwoodworks
  class TagRecord < Sequel::Model(:tags)
    one_to_many :record
  end
end
