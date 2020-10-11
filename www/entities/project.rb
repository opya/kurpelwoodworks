require 'mobility'
require_relative './project/project_images'
require_relative './project/project_mandoc_template'

class Project < Sequel::Model
  plugin :mobility

  translates :name,         backend: :key_value, type: :string
  translates :description,  backend: :key_value, type: :text

  one_to_many :project_images

  def validate
    super

    errors.add(:work_name, 'cannot be empty') if !work_name || work_name.empty?
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    errors.add(:description, 'cannot be empty') if !description || description.empty?
    errors.add(:started, 'is invalid date') unless validate_date(self[:started])
    errors.add(:completed, 'is invalid date') unless validate_date(self[:completed])
  end

  def before_create
    load_images!
    super
  end

  #TODO: this whould be done with db constraint 
  def before_destroy
    self.project_images.map(&:destroy)
    super
  end

  def started
    _preview_date(self[:started])
  end

  def completed
    _preview_date(self[:completed])
  end

  def images
    project_images
  end

  def logo_image
    images.first
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

  def load_images!
    ProjectImage.for_project(self)
  end
end
