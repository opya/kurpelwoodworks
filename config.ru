$:.unshift(File.expand_path("../", __FILE__))

require 'web/kurpel'

run Kurpelwoodworks::Router.freeze.app
