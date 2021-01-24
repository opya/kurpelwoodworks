require 'roda'
require 'roda/session_middleware'
require 'pagy'
require 'pagy/extras/bulma'
require 'pry' unless ENV["production"]
require_relative 'db'

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

  STATIC_ASSETS = [
    '/assets/webfonts',
    '/assets/images',
    '/assets/photoswipe',
    '/assets/mandoc.css'
  ]

  use RodaSessionMiddleware, secret: '1'*64

  plugin :static, STATIC_ASSETS
  plugin :render, esacape: true, views: "./public/templates",
          template_opts: { default_encoding: 'UTF-8' }
  plugin :assets, css: ['all.scss'], js: JS_ASSETS, path: "./assets"
  plugin :common_logger, $stdout
  plugin :csrf

  compile_assets

  route do |r|
    r.assets

    r.root do
      #view("home", layout: 'home_layout')
      view("home")
    end

    r.on "kurpel" do
      view("kurpel")
    end

    r.on "contacts" do
      r.post do
        contact = r.params["contact"]

        m = MMail.new(
          contact["name"],
          contact["email"],
          contact["phone"],
          contact["message"]
        )
        m.new_contact_form_message

        @sent = m.valid? ? true : false

        view("contacts")
      end

      r.get do
        view("contacts")
      end
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
