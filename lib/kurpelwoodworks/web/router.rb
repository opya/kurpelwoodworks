require 'roda'
require 'roda/session_middleware'
require 'kurpelwoodworks/lib/roda/plugins/cors'

module Kurpelwoodworks
  class Router < Roda
    use RodaSessionMiddleware, secret: '1'*64

    plugin :hash_routes
    plugin :enhanced_logger, trace_missing: true
    plugin :route_list, file: 'lib/kurpelwoodworks/web/routes.json'
    plugin :json
    #plugin :cors, allowed_origins: ['https://kurpelwoodworks.com/']
    plugin :cors

    require 'kurpelwoodworks/web/routes/contacts'
    require 'kurpelwoodworks/web/routes/notes'

    route do |r|
      r.hash_routes

      # route: /
      r.root do
        { date: DateTime.now }
      end
    end
  end
end
