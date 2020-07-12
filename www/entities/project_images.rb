require 'mini_magick'
require 'fileutils'

class ProjectImage < Sequel::Model
  many_to_one :project

  BASE_IMAGES_PATH = "public/assets/images/"
  TEMPLATES_PATH = "/assets/images"
  CASHE_DIR = "cache/"
  SCALE_PERCENT = "10%"
  THUMBNAIL_PATH = ""

  class << self
    def for_project(project)
      if File.exist?("#{BASE_IMAGES_PATH}#{project.work_name}")
        images = Dir.entries("#{BASE_IMAGES_PATH}#{project.work_name}")
        images.sort!
        images.reject!{ |i| i == '.' || i == '..' || i == 'cache'}

        images.each do |image_name|
          ProjectImage.new(project: project, name: image_name).save
        end
      end
    end
  end

  def before_save
    generate_thumbnail!
    super
  end

  private

  def generate_thumbnail!
    image = MiniMagick::Image.open("#{BASE_IMAGES_PATH}#{project.work_name}/#{name}")

    self.path = "#{TEMPLATES_PATH}#{project.work_name}/#{File.basename(name)}"
    self.width = image.width
    self.height = image.height

    unless File.exist?("#{BASE_IMAGES_PATH}#{project.work_name}/#{CASHE_DIR}")
      FileUtils.mkdir_p("#{BASE_IMAGES_PATH}#{project.work_name}/#{CASHE_DIR}")
    end

    unless cache_thumbnail_exists?
      thumbnail = image
      thumbnail.resize(SCALE_PERCENT)
      thumbnail.write("#{BASE_IMAGES_PATH}#{project.work_name}/#{CASHE_DIR}#{name}")

      self.thumbnail_path = "#{TEMPLATES_PATH}/#{project.work_name}/#{CASHE_DIR}#{name}"
      self.thumbnail_width = thumbnail.width
      self.thumbnail_height = thumbnail.height
    end
  end

  def cache_thumbnail_exists?
    File.exist?("#{BASE_IMAGES_PATH}#{project.work_name}/#{CASHE_DIR}#{name}")
  end
end
