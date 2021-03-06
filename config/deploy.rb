set :application, "donebox.com"
set :repository, "http://code.macournoyer.com/svn/donebox/trunk"

role :web, application
role :app, application
role :db,  application, :primary => true

set :deploy_via, :remote_cache
set :deploy_to, "/home/macournoyer/#{application}"

set :use_sudo, false
set :user, 'macournoyer'
