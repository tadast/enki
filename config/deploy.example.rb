set :deploy_via, :remote_cache
set :use_sudo, false
set :application, "enki"
set :scm, :git
set :repository, "git://github.com/zed-0xff/enki.git"
set :deploy_to, "/PATH/TO/DEPLOY/#{application}"
set :user, 'USER_TO_DEPLOY_AS'

server "SERVER_TO_DEPLOY_TO", :app, :web, :db, :primary => true

necessary_shared_configs = %w'database.yml enki.yml initializers/secret_token.rb initializers/amazon_ses.rb'
optional_shared_configs = %w''

require 'bundler/capistrano'

namespace :deploy do
  task :symlink_shared_configs do
    necessary_shared_configs.each do |config|
      shared_config = "#{shared_path}/config/#{config}"
      run "test -f #{shared_config} && ln -s #{shared_config} #{latest_release}/config/#{config}"
    end

    optional_shared_configs.each do |config|
      shared_config = "#{shared_path}/config/#{config}"
      run "test -f #{shared_config} && ln -s #{shared_config} #{latest_release}/config/#{config}; true"
    end

    run "ln -s #{shared_path}/locks #{latest_release}/"
  end

  task :restart do
    run "touch #{latest_release}/tmp/restart.txt"
  end

  task :start do
    run "touch #{latest_release}/tmp/restart.txt"
  end

  task :stop do
  end
end

after "deploy:finalize_update", "deploy:symlink_shared_configs"
