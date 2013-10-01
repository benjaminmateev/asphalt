set :application, "asphalt-berlin.com"

set :scm, :none
set :repository, "."
set :deploy_via, :copy

set :user, :root

role :web, "ben.urbanvention.com"                          # Your HTTP server, Apache/etc
role :app, "ben.urbanvention.com"                          # This may be the same as your `Web` server
role :db,  "ben.urbanvention.com", :primary => true # This is where Rails migrations will run

set :deploy_to,   "/home/#{application}"

set :use_sudo, false
ssh_options[:paranoid] = false

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :configure do
  task :set_config_link do
    run "ln -s #{shared_path}/config/* #{current_release}/config/"
  end
  task :set_db_link do
    run "ln -s #{shared_path}/db/production.sqlite3 #{current_release}/db/production.sqlite3"
  end
  task :set_permissions do
    run "chown -R www-data:www-data #{deploy_to}"
  end
end

namespace :apache do
  task :restart do
    run "/etc/init.d/apache2 restart"
  end
end

# after deploy hooks
after :deploy do
  #configure.set_config_link
  configure.set_db_link
  configure.set_permissions
  apache.restart
end