require "roda"
require 'roda/session_middleware'
require "pry"

class Kurpelwoodworks < Roda
  SUPPORTED_LOCALES = ['bg', 'en']

  use RodaSessionMiddleware, secret: '1'*64
  plugin :static, ['/assets/webfonts', '/assets/images']
  plugin :render, esacape: true, views: "./public/templates",
          template_opts: { default_encoding: 'UTF-8' }
  plugin :assets, css: ['all.scss'], js: ['navbar.js'], path: "./"
  plugin :i18n, locale: SUPPORTED_LOCALES, default_locale: :bg
  plugin :common_logger, $stdout

  compile_assets

  route do |r|
    r.assets
    r.i18n_set_locale_from(:session)

    r.root do
      view("home")
    end

    r.on "about" do
      view("about")
    end

    r.on "portfolio" do
      view("portfolio")
    end

    r.on "contacts" do
      view("contacts")
    end

    r.get "locale", String do |locale|
      change_locale(locale)
      r.redirect r.referer
    end
  end

  private

  def change_locale(locale)
    session[:locale] = locale if SUPPORTED_LOCALES.include?(locale)
  end
end

run Kurpelwoodworks.freeze.app
