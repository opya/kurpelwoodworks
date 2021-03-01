require 'roda'
require 'roda/session_middleware'
require 'i18n'
require 'pry' unless ENV["production"]
require 'lib/roda/plugins/cors'
require 'config/db'

I18n.load_path << Dir.glob("./config/i18n/**/*.yml")
I18n.default_locale = :bg

module Kurpelwoodworks
  class Router < Roda
    use RodaSessionMiddleware, secret: '1'*64

    plugin :hash_routes
    plugin :enhanced_logger, trace_missing: true
    plugin :route_list, file: './web/routes.json'
    plugin :json
    #plugin :cors, allowed_origins: ['https://kurpelwoodworks.com/']
    plugin :cors

    require 'web/routes/contacts'
    require 'web/routes/records'

    route do |r|
      r.hash_routes

      # route: /
      r.root do
        { date: DateTime.now }
      end
    end
  end
end
