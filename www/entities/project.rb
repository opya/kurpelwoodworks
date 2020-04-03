require 'mobility'

class Project < Sequel::Model
  plugin :mobility

  translates :name, backend: :key_value, type: :string
  translates :description, backend: :key_value, type: :text

  def validate
    super

    errors.add(:work_name, 'cannot be empty') if !work_name || work_name.empty?
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

  private

  def validate_date(date)
    begin
      DateTime.strptime(date.to_s, '%s')
    rescue StandardError
      return false
    end

    true
  end
end
