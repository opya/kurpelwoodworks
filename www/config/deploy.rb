require 'mina/rails'
require 'mina/git'

set :application_name, 'kurpelwoodworks'
set :domain, 'kurpelwoodworks.com'
set :deploy_to, '/var/www/htdocs/kurpelwoodworks.com'
set :repository, 'git@bitbucket.org:opya/kurpelwoodworks.git'
set :branch, 'master'
set :forward_agent, true     # SSH forward_agent.

task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{cd www && bundle install --path=~/.gems}
        #command %{RACK_ENV=production bundle exec pumactl restart}
      end
    end
  end
end
