set :deploy_via, :remote_cache
set :use_sudo, false
set :application, "enki"
set :scm, :git
set :repository, "git://github.com/zed-0xff/enki.git"
set :deploy_to, "/PATH/TO/DEPLOY/#{application}"
set :user, 'USER_TO_DEPLOY_AS'

server "SERVER_TO_DEPLOY_TO", :app, :web, :db, :primary => true

shared_configs = %w'database.yml mongrel_cluster.yml enki.yml'

namespace :deploy do
  task :symlink_shared_configs do
    shared_configs.each do |config|
      run "ln -s #{shared_path}/config/#{config} #{latest_release}/config/"
    end

    run "ln -s #{shared_path}/locks #{latest_release}/"
  end

  task :restart do
    run "mongrel_rails cluster::restart -C #{latest_release}/config/mongrel_cluster.yml"
  end

  task :start do
    run "mongrel_rails cluster::start -C #{latest_release}/config/mongrel_cluster.yml"
  end

  task :stop do
    run "mongrel_rails cluster::stop -C #{latest_release}/config/mongrel_cluster.yml"
  end

end

after "deploy:finalize_update", "deploy:symlink_shared_configs"
