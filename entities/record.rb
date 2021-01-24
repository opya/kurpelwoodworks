class Record < Sequel::Model
  many_to_many :tags
end
