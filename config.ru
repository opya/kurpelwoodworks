require_relative 'init'
require_relative 'web/router'

run Router.freeze.app
