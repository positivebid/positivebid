require "bundler/capistrano"
require "delayed/recipes"  

set :application, "positive"
set :stage, nil
set :rake, "bundle exec rake"


# eg.  cap production deploy
task :production do
  set :stage, "production"
  set :rails_env, "production"
  set :my_rails_env,  "production"
  set :website, "www.positivebid.com"
  set :web_server,  "bid1.positivebid.com"
  set :branch, "stable"
  set :user, "positive"
  set :keep_releases, 4
  set :gitwee, false
  set :deploy_to, "/home/#{user}/#{website}/#{application}"
  set :rake, "RAILS_ENV=#{my_rails_env} bundle exec rake"
  role :app, web_server
  role :web, web_server
  role :db,  web_server, :primary => true
end

task :staging do
  set :stage, "staging"
  set :rails_env, "staging"
  set :my_rails_env, "staging"
  set :website, "alpha.positivebid.com"
  set :web_server,  "bid1.positivebid.com"
  set :branch, "master"
  set :user, "positive"
  set :keep_releases, 2
  set :gitwee, false
  set :deploy_to, "/home/#{user}/#{website}/#{application}"
  set :rake, "RAILS_ENV=#{my_rails_env} bundle exec rake"
  role :app, web_server
  role :web, web_server
  role :db,  web_server, :primary => true
end

before 'deploy' do
  abort "ERROR: No stage specified. Please specify one of: staging, production (e.g. 'cap staging deploy')" if stage.nil?
end


set :use_sudo, false
default_run_options[:pty] = true # required with capistrano 2.1 on solaris

set :scm, :git
set :repository,  "git@github.com:positivebid/positive.git"
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
#set :copy_cache, true
set :copy_exclude, %w( .git .gitignore test )
#set :deploy_via, :fast_remote_cache 



# # #

namespace :deploy do

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt" 
  end 

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "symlink shared cache"
  task :symlink_shared_cache do
    run "mkdir -p #{shared_path}/cache ; rm -rf #{deploy_to}/current/tmp/cache ; ln -s #{shared_path}/cache #{deploy_to}/current/tmp/cache"
  end

end

after 'deploy' do
  #jason.symlink_assets
  deploy.cleanup
  jason.email_notification
  if gitwee
    #jason.gitwee
  end
end

set :to_email, "tech@positivebid.com"
namespace :jason do

  desc "email a notice after deployment"
  task :email_notification do
    run "mailx -s \"#{application} has been deployed to #{web_server}\" #{to_email} << /dev/null"
  end

  desc "run gitwee"
  task :gitwee do
    run "#{deploy_to}/current/extras/gitwee #{deploy_to}/shared/cached-copy" 
  end

  desc "symlink image related assets"
  task :symlink_assets do
    %w(pictures photos).each do |dir|
      run "mkdir -p #{shared_path}/public_assets/#{dir} ; rm -rf #{deploy_to}/current/public/#{dir} ; ln -s #{shared_path}/public_assets/#{dir} #{deploy_to}/current/public/#{dir}"
    end
  end

end

after "deploy:symlink", "deploy:symlink_shared_cache"


#TOOD before "deploy:restart", "delayed_job:stop"
#TOOD after  "deploy:restart", "delayed_job:start"

#TOOD after "deploy:stop",  "delayed_job:stop"
#TOOD after "deploy:start", "delayed_job:start"


require './config/capistrano_db_dump_and_clone_to_local'
