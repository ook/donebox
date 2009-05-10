ActionController::Routing::Routes.draw do |map|
  map.resources :tasks, :member     => { :complete => :post, :uncomplete => :post },
                        :collection => { :sort => :post, :completed => :get }

  map.resources :users, :sessions
  
  map.signup 'signup', :controller => 'users',    :action => 'new'
  map.login  'login',  :controller => 'sessions', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'

  map.home '', :controller => 'tasks'
  
  map.with_options :controller => 'about' do |about|
    about.api 'api',     :action => 'api'
    about.about 'about', :action => 'index'
    about.tools 'tools', :action => 'tools'
    about.syntax 'syntax', :action => 'syntax'
  end

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
