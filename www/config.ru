require 'roda'
require 'roda/session_middleware'
require 'pry' unless ENV["production"]
require_relative 'db'
require_relative 'entities/project'
require_relative 'entities/locale'
require_relative 'entities/mmail'

I18n.load_path << "i18n/i18n.yml"

class Kurpelwoodworks < Roda
  JS_ASSETS = ['navbar.js', 'contact_form.js']

  use RodaSessionMiddleware, secret: '1'*64

  plugin :static, ['/assets/webfonts', '/assets/images']
  plugin :render, esacape: true, views: "./public/templates",
          template_opts: { default_encoding: 'UTF-8' }
  plugin :assets, css: ['all.scss'], js: JS_ASSETS, path: "./assets"
  plugin :i18n, locale: Locale::SUPPORTED_LOCALES, default_locale: :bg
  plugin :common_logger, $stdout
  plugin :csrf

  compile_assets

  route do |r|
    r.assets
    r.i18n_set_locale_from(:session)
    change_locale

    r.root do
      view("home")
    end

    r.on "kurpel" do
      view("kurpel")
    end

    r.on "portfolio" do
      r.get "project", String do |work_name|
        @project = Project.find(work_name: work_name)
        
        p @project.name
      end

      r.get do
        # NOTE: pageing will be needed when projects count grown
        @projects = Project.all
        view("portfolio")
      end
    end

    r.on "contacts" do
      r.post do
        contact = r.params["contact"]

        MMail.new(
          contact["name"],
          contact["email"],
          contact["phone"],
          contact["message"]
        ).new_contact_form_message

        @sent = 1
        view("contacts")
      end

      r.get do
        view("contacts")
      end
    end

    r.get "locale", String do |locale|
      change_locale(locale)
      r.redirect r.referer
    end
  end

  private

  def change_locale(locale = nil)
    l = session["locale"] ? session["locale"] : :bg
    l = locale if locale && Locale::SUPPORTED_LOCALES.include?(locale)

    session[:locale] = l
    I18n.locale = l
  end
end

run Kurpelwoodworks.freeze.app
