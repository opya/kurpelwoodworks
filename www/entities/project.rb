require 'mobility'
require_relative './images'

class Project < Sequel::Model
  plugin :mobility

  translates :name,         backend: :key_value, type: :string
  translates :description,  backend: :key_value, type: :text

  def validate
    super

    errors.add(:work_name, 'cannot be empty') if !work_name || work_name.empty?
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    errors.add(:description, 'cannot be empty') if !description || description.empty?
    errors.add(:started, 'is invalid date') unless validate_date(self[:started])
    errors.add(:completed, 'is invalid date') unless validate_date(self[:completed])
  end

  def started
    _preview_date(self[:started])
  end

  def completed
    _preview_date(self[:completed])
  end

  def images
    _images
  end

  def logo_image
    _images.first
  end

  private

  def validate_date(date)
    begin
      DateTime.strptime(date.to_s, '%s') if date
    rescue StandardError
      return false
    end

    true
  end

  def _preview_date(date)
    Time.at(date).strftime("%Y-%m-%d") if date
  end

  def _images
    @images ||= (Images.for_project(self.work_name) unless new?) || []
  end
end
