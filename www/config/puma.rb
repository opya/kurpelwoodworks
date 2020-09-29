workers 3
worker_timeout 30
worker_boot_timeout 30

env = ENV['RACK_ENV'] || 'development'

if env == 'production'
  app_dir = '/var/www/htdocs/kurpelwoodworks.com/current/www'
  shared_dir = '/var/www/htdocs/kurpelwoodworks.com/shared'
  pid_file = '/tmp/puma.pid'
  sock_file = '/tmp/puma.sock'

  environment 'production'
  directory app_dir
  pidfile shared_dir + pid_file
  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
  bind 'tcp://127.0.0.1:9292'
  #bind "unix://#{shared_dir + sock_file}"

  daemonize
end

before_fork do
  DB.disconnect
end

preload_app!
