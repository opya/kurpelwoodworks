workers 3
worker_timeout 30
worker_boot_timeout 30

env = ENV['RACK_ENV'] || 'development'

if env == 'production'
  app_dir = '/var/www/htdocs/kurpelwoodworks.com/current/www'
  pid_file = '/var/www/htdocs/kurpelwoodworks.com/shared/tmp/puma.pid'

  environment 'production'
  directory app_dir
  pidfile pid_file 
  bind 'tcp://127.0.0.1:9292'

  daemonize
end

before_fork do
  DB.disconnect
end

preload_app!
