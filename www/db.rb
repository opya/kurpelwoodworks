if ENV["production"]
  KURPEL_DB = "kurpelwoodworks.db"
else
  KURPEL_DB = "dev_kurpelwoodworks.db"
end

unless File.exist?(KURPEL_DB)
  raise StandardError, sprintf("%s don't exists", KURPEL_DB)
end

require 'sequel'
require 'logger'
require 'tempfile'

Sequel::Model.plugin :timestamps, update_on_create: true

DB = Sequel.connect("sqlite://#{KURPEL_DB}")
DB.loggers << Logger.new($stdout)