Kurpelwoodworks::Application.boot(:db) do
  init do
    unless File.exist?(ENV["KURPEL_DB"])
      raise StandardError, sprintf("%s don't exists", ENV["KURPEL_DB"])
    end

    require 'sequel'
    require 'logger'
    require 'tempfile'

    Sequel::Model.plugin :timestamps, update_on_create: true
    Sequel::Model.plugin :validation_helpers
    Sequel::Model.plugin :prepared_statements

    connection = Sequel.connect("sqlite://#{ENV["KURPEL_DB"]}")
    connection.loggers << Logger.new($stdout)

    register("db.connection", connection)
  end
end
