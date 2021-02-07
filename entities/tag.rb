class Tag < Sequel::Model
  one_to_many :record
end
