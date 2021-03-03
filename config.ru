require_relative 'config/application'
Kurpelwoodworks::Application.finalize!

require 'kurpelwoodworks/web/router'

run Kurpelwoodworks::Router.freeze.app
