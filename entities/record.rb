class Record < Sequel::Model
  many_to_many :tags

  def validate
    super

    validates_presence :name, message: 'Въведете име на записа'
    validates_min_length 10, :name, message: 'Името трябва да е повече от 10 символа'
    validates_max_length 150, :name, message: 'Името трябва да е по-малко от 150 символа' 

    validates_presence :description, message: 'Въведете описание на записа'
    validates_min_length 20, :description, message: 'Описанието трябва да е повече от 20 символа'
  end
end
