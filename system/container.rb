require 'dry/system/container'

class Container < Dry::System::Container
  configure do |config|
	config.root = Pathname(File.expand_path('../../app', __FILE__))
	config.auto_register = %w(lib models entities repositories actions validations presenters)
  end

  load_paths!(*%w(lib models entities repositories actions validations presenters))
end
