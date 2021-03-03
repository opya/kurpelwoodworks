require_relative "boot"
require "dry/system/container"

module Kurpelwoodworks
  class Application < Dry::System::Container
    configure do |config|
      config.root = File.expand_path('..', __dir__)
      config.default_namespace = "kurpelwoodworks"
      config.auto_register = %w(lib)
    end

    load_paths!(*%w(lib))
  end

  Import = Dry::AutoInject(Application)
end
