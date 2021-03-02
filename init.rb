$:.unshift(File.expand_path("../", __FILE__))

require 'config/db'
require 'i18n'
require 'pry' unless ENV["production"]

I18n.load_path << Dir.glob("./config/i18n/**/*.yml")
I18n.default_locale = :bg
