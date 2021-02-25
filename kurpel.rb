require 'roda'
require 'roda/session_middleware'
require 'i18n'
require 'pagy'
require 'pagy/extras/metadata'
require_relative './lib/roda/plugins/cors'
require_relative './config/db'
require 'pry' unless ENV["production"]

I18n.load_path << Dir[File.expand_path("./config/i18n") + "/*.yml"]
I18n.default_locale = :bg

class Kurpelwoodworks < Roda
  include Pagy::Backend

  use RodaSessionMiddleware, secret: '1'*64

  plugin :hash_routes
  plugin :enhanced_logger, trace_missing: true
  plugin :route_list
  plugin :json
  plugin :cors
  #plugin :route_csrf

  require_relative 'routes/contacts'
  require_relative 'routes/records'

  route do |r|
    r.hash_routes

    # route: /
    r.root do
      { date: DateTime.now }
    end
  end

  private

  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: request.params["page"],
      items: vars[:items] || 4 
    }
  end
end
