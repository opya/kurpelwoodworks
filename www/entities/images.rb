class Images
  BASE_PROJECT_IMAGES_PATH = "public/assets/images/".freeze
  TEMPLATES_PATH = "/assets/images".freeze

  class << self
    def for_project(name)
      images = Dir.entries("#{BASE_PROJECT_IMAGES_PATH}#{name}")
      images.sort!
      images.reject!{ |i| i == '.' || i == '..' }
      images.collect!{ |i| "#{TEMPLATES_PATH}/#{name}/#{i}" }
      images
    end
  end
end
