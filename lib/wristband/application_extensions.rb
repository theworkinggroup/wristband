module Wristband
  module ApplicationExtensions
    def self.included(base)
      base.send(:extend, Wristband::ApplicationExtensions::ClassMethods)
      base.send(:include, Wristband::ApplicationExtensions::InstanceMethods)
      base.send(:helper_method, :logged_in?, :session_user) if base.respond_to?(:helper_method)
    end

    module ClassMethods
      # ...
    end

    module InstanceMethods
      def authenticate_and_login(username, password, remember_me=false)
        if user = ::User.authenticate(username, password)
          login_as_user(user, remember_me)
          user
        end
      end
    
      def login_as_user(user, remember_me=false)
        self.session_user = user
        if remember_me
          token = Support.encrypt_with_salt(user.id.to_s, Time.now.to_f.to_s)
          cookies[:login_token] = { :value => token, :expires => 2.weeks.from_now.utc }
          user.update_attribute(:remember_token, token)
        end
      end
  
      # Logs a user out and deletes the remember_token.
      def logout
        session_user.update_attribute(:remember_token, nil) if session_user
        cookies.delete(:login_token)    
        reset_session
      end  
    
      # Returns true if a user is logged in
      def logged_in?
        !!session_user
      end
    
      # Returns the current user in session. Use this on your views and controllers.
      def session_user
        @session_user ||= (session[:user_id] and ::User.find_by_id(session[:user_id]))
      end

      # Sets the current user in session
      def session_user=(user)
        @session_user = user
        session[:user_id] = (user and user.id)
      end
    
      # Logs a user automatically from his cookie
      #
      # You can use this function as a before filter on your controllers.
      def login_from_cookie
        return if (logged_in? or !cookies[:login_token])
        self.session_user = ::User.find_by_remember_token(cookies[:login_token])
      end
    
      # You can use this function as a before filter on your controllers that require autentication.
      #
      # If the user is not logged in +respond_not_logged_in+ will be called.
      def login_required
        unless logged_in?
          respond_not_logged_in
          return false
        end
      end
    
      # Override this on your controllers to specify what to do when the user is not logged in.
      def respond_not_logged_in
        false
      end
    
    end
  end
end