require 'roda'
require 'roda/session_middleware'
require 'lib/roda/plugins/cors'

class Router < Roda
  use RodaSessionMiddleware, secret: '1'*64

  plugin :hash_routes
  plugin :enhanced_logger, trace_missing: true
  plugin :route_list, file: './web/routes.json'
  plugin :json
  #plugin :cors, allowed_origins: ['https://kurpelwoodworks.com/']
  plugin :cors

  require 'web/routes/contacts'
  require 'web/routes/notes'

  route do |r|
    r.hash_routes

    # route: /
    r.root do
      { date: DateTime.now }
    end
  end
end
