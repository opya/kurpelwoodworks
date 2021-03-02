require 'dry/system/container'

class Container < Dry::System::Container
  configure do |config|
	config.root = Pathname(File.expand_path('../..', __FILE__))
	config.auto_register = %w(lib actions repositories records models presenters validations)
  end

  load_paths!(*%w(lib actions repositories records models presenters validations))
end
