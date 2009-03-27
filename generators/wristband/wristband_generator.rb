class WristbandGenerator < Rails::Generator::Base 
  def manifest 
    record do |m| 
      # User files
      m.directory 'app/models'
      m.template 'app/models/user.rb', 'app/models/user.rb'
      m.directory 'app/controllers'
      m.template 'app/controllers/users_controller.rb', 'app/controllers/users_controller.rb'
      m.directory 'app/views/users'
      m.template 'app/views/users/index.html.haml', 'app/views/users/index.html.haml'

      # User notifier files
      m.directory 'app/models'
      m.template 'app/models/user_notifier.rb', 'app/models/user_notifier.rb'
      m.directory 'app/views/user_notifier'
      m.file 'app/views/user_notifier/forgot_password.text.html.rhtml', 'app/views/user_notifier/forgot_password.text.html.rhtml'
      m.file 'app/views/user_notifier/forgot_password.text.plain.rhtml', 'app/views/user_notifier/forgot_password.text.plain.rhtml'
      m.file 'app/views/user_notifier/email_verification.text.html.rhtml', 'app/views/user_notifier/email_verification.text.html.rhtml'
      m.file 'app/views/user_notifier/email_verification.text.plain.rhtml', 'app/views/user_notifier/email_verification.text.plain.rhtml'

      
      # Session files
      m.directory 'app/controllers'
      m.template 'app/controllers/sessions_controller.rb', 'app/controllers/sessions_controller.rb'
      m.directory 'app/views/sessions'
      m.template 'app/views/sessions/new.html.haml', 'app/views/sessions/new.html.haml'
      
      # Migrations
      m.directory 'db/migrate'
      m.migration_template 'db/migrate/create_wristband_tables.rb', 'db/migrate', :migration_file_name => "create_wristband_tables"

      # Routes
      m.add_route %{
  # Edit these as needed ...
  map.with_options :controller => 'sessions' do |session|
    session.login   '/login',   :action => 'new',     :conditions => { :method => :get }
    session.login   '/login',   :action => 'create',  :conditions => { :method => :post }
    session.logout  '/logout',  :action => 'destroy'
  end

  map.with_options :controller => 'users' do |user|
    user.register         '/register',   :action => 'new',     :conditions => { :method => :get }
    user.register         '/register',   :action => 'create',  :conditions => { :method => :post }
    user.verify_email     '/users/verify_email/:email_validation_key', :action => 'verify_email', :conditions => { :method => :get }
    user.forgot_password  '/forgot_password', :action => 'forgot_password'
  end

  map.home  '/',  :controller => 'users', :action => 'index'
      }
      m.route_resources :sessions, :users
    end
  end
  
  def file_name
    'wristband'
  end
  
  class Rails::Generator::Commands::Create
    def add_route(text)
      sentinel = 'ActionController::Routing::Routes.draw do |map|'
      logger.route "specific routes"
      unless options[:pretend]
        gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
          "#{match}\n  #{text}\n"
        end
      end
    end
  end
end
