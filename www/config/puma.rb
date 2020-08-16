workers 3
worker_timeout 30
worker_boot_timeout 30

env = ENV['RACK_ENV'] || 'development'

if env == 'production'
  app_dir = '/var/www/htdocs/kurpelwoodworks.com/current'

  environment 'production'
  directory app_dir
  pidfile app_dir + '/tmp/puma.pid'
  pidfile app_dir + '/tmp/puma.pid'
  bind 'tcp://0.0.0.0:9292'

  daemonize
end

before_fork do
  DB.disconnect
end

preload_app!
