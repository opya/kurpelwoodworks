class Project < Sequel::Model
  one_to_many :project_images

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    errors.add(:description, 'cannot be empty') if !description || description.empty?
    errors.add(:started, 'is invalid date') unless validate_date(started)
    errors.add(:completed, 'is invalid date') unless validate_date(completed)
  end

  def around_save
    self.started = Date.parse(self.started).to_time.to_i
    self.completed = Date.parse(self.completed).to_time.to_i
    super
  end

  def validate_date(date)
    begin
      Date.parse(date)
    rescue StandardError
      return false
    end

    true
  end
end
