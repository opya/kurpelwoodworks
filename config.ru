require 'roda'
require 'roda/session_middleware'
require 'i18n'
require 'pagy'
require 'pagy/extras/bulma'
require 'pry' unless ENV["production"]
require_relative 'db'
require_relative 'config/forme_bulma'

I18n.load_path << Dir[File.expand_path("./config/i18n") + "/*.yml"]
I18n.default_locale = :bg

class Kurpelwoodworks < Roda
  include Pagy::Backend
  include Pagy::Frontend

  JS_ASSETS = {
    layout: 'navbar.js',
    contact_form: 'contact_form.js',
    photoswipe: [
      'photoswipe-ui-default.min.js',
      'photoswipe.min.js'
    ]
  }

  STATIC_ASSETS = ['/assets/webfonts', '/assets/images', '/assets/photoswipe']

  use RodaSessionMiddleware, secret: '1'*64

  plugin :hash_routes
  plugin :static, STATIC_ASSETS
  plugin :render, esacape: true, views: "./public/templates",
          template_opts: { default_encoding: 'UTF-8' }
  plugin :assets, css: ['all.scss'], js: JS_ASSETS, path: "./assets"
  plugin :common_logger, $stdout
  plugin :forme_route_csrf

  compile_assets

  require_relative 'routes/contacts'
  require_relative 'routes/records'

  route do |r|
    r.assets
    r.hash_routes

    r.root do
      #view("home", layout: 'home_layout')
      view("home")
    end
  end

  private

  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: request.params["page"],
      items: vars[:items] ||  4
    }
  end
end

run Kurpelwoodworks.freeze.app