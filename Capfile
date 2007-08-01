load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'config/deploy'

task :restart_web_server, :roles => :web do
  run "touch #{release_path}/public/dispatch.fcgi" 
end

after "deploy:restart", :restart_web_server

task :symlink_database_yml do
   run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
end

before "deploy:finalize_update", :symlink_database_yml