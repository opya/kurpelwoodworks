require 'roda'
require 'roda/session_middleware'
require 'pry'
require_relative 'db'
require_relative 'entities/project'
require_relative 'entities/locale'

I18n.load_path << "i18n/i18n.yml"
I18n.locale = :bg

class Kurpelwoodworks < Roda
  use RodaSessionMiddleware, secret: '1'*64
  plugin :static, ['/assets/webfonts', '/assets/images']
  plugin :render, esacape: true, views: "./public/templates",
          template_opts: { default_encoding: 'UTF-8' }
  plugin :assets, css: ['all.scss'], js: ['navbar.js'], path: "./assets"
  plugin :i18n, locale: Locale::SUPPORTED_LOCALES, default_locale: :bg
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
      # NOTE: pageing will be needed when projects count grown
      @projects = Project.all
      view("portfolio")
    end

    r.on "project", String do "work_name"
      abort "TODO"
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
    if Locale::SUPPORTED_LOCALES.include?(locale)
      session[:locale] = locale
      I18n.locale = locale
    end
  end
end

run Kurpelwoodworks.freeze.app
