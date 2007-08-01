set :application, "donebox.com"
set :repository, "http://code.macournoyer.com/private/yellowbox/trunk"

role :web, "donebox.com"
role :app, "donebox.com"
role :db,  "donebox.com", :primary => true

set :deploy_to, "/home/macournoyer/#{application}"
set :use_sudo, false
set :checkout, "export"
set :user, 'macournoyer'