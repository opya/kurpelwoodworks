require "roda"

class Kurpelwoodworks < Roda
  plugin :static, ['/assets/webfonts', '/assets/images']
  plugin :render,
    esacape: true,
    views: "./public/templates",
    template_opts: {default_encoding: 'UTF-8'}
  plugin :assets, css: ['all.scss'], js: ['navbar.js'], path: "./"

  compile_assets

  route do |r|
    r.assets

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
  end
end

run Kurpelwoodworks.freeze.app
