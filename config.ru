require_relative 'init'
require 'web/kurpel'

run Kurpelwoodworks::Router.freeze.app
