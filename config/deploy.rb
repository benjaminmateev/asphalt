require "bundler/capistrano"

default_run_options[:pty] = true
set :application, "asphalt-berlin.com"

set :scm, :git
set :repository, "git@github.com:benjaminmateev/asphalt.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_via, :copy

set :user, :root

role :web, "198.211.120.82"                          # Your HTTP server, Apache/etc
role :app, "198.211.120.82"                          # This may be the same as your `Web` server
role :db,  "198.211.120.82", :primary => true # This is where Rails migrations will run

set :deploy_to,   "/home/deploy/#{application}"

set :use_sudo, false
set :ssh_options, { :forward_agent => true, :paranoid => true }

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  # task :setup_config, roles: :app do
  #   sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
  #   sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  # end
  # after "deploy:setup", "deploy:setup_config"
end

# If you are using Passenger mod_rails uncomment this:
namespace :configure do
  task :set_config_link do
    run "ln -s #{shared_path}/config/* #{current_release}/config/"
  end
  task :set_db_link do
    run "ln -s #{shared_path}/db/production.sqlite3 #{current_release}/db/production.sqlite3"
  end
end

# after deploy hooks
after :deploy do
  #configure.set_config_link
  configure.set_db_link
end
