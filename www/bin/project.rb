#!/usr/local/bin/ruby

require 'optparse'
require 'pry'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: project [options]"

  opts.on("-l LOCALE", "When updating project, set locale\n") do |o|
    options[:locale] = o 
  end

  opts.on("-n", "New Project procedure.") do |o|
    options[:new] = o
  end

  opts.on("-u WORK_NAME", "Update Project procedure with work name and locale.") do |o|
    options[:update] = o
  end

  opts.on("-d", "Debug mode, log db interaction.") do |o|
    options[:debug] = o
  end

  opts.on("-D", "IRB console.") do |o|
    options[:irb] = o
  end
end.parse!

KURPEL_DB = "kurpelwoodworks.db"

unless File.exist?(KURPEL_DB)
  raise StandardError, sprintf("%s don't exists", KURPEL_DB)
end

require 'sequel'
require 'logger'
require 'tempfile'

Sequel::Model.plugin :timestamps, update_on_create: true

DB = Sequel.connect("sqlite://#{KURPEL_DB}")
DB.loggers << Logger.new($stdout) if options.has_key? :debug

require_relative '../entities/project'
require_relative '../entities/create_project'

I18n.load_path << Dir[File.expand_path("i18n") + "/*.yml"]

if options.has_key? :new
  I18n.locale = :bg
  CreateProject.new(Project.new).run
elsif options.has_key?(:update)
  require_relative '../entities/locale'

  if options.has_key?(:locale)
    if Locale::SUPPORTED_LOCALES.include?(options[:locale])
      I18n.locale = options[:locale]
      project = Project.find(work_name: options[:update])

      if project
        CreateProject.new(project).run
      else
        puts "Cant find Project with work name '#{options[:update]}'"
      end
    else
      puts "Wrong locale. Supported locales: #{Locale::SUPPORTED_LOCALES.join(', ')}"
    end
  else
    puts "Locale must be set before project is updated. " + \
          "Supported locales: #{Locale::SUPPORTED_LOCALES.join(', ')}"
  end
elsif options.has_key?(:irb)
  system("irb -r ./bin/project.rb")
end
