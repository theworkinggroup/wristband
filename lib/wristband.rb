require 'wristband/user_extensions'
require 'wristband/support'
require 'wristband/application_extensions'
require 'wristband/authority_check'

module Wristband
  module ClassMethods
    def wristband(options={})
      options[:login_with]            ||= [:username]
      options[:before_authentication] ||= []
      options[:after_authentication]  ||= []
      options[:plain_text_password]   ||= false
      options[:has_authorities]       ||= false
      options[:roles]                 ||= []
      
      class_eval do
        include Wristband::UserExtensions
        
        if options[:plain_text_password]
          options[:password_column] ||= :password
        else
          options[:password_column] ||= :password_crypt
          
          # These two are used on the login form
          attr_accessor :password
          attr_accessor :password_confirmation
          
          before_save :encrypt_password
        end
          
        # Add roles
        unless options[:roles].blank?
          options[:roles].each do |role|
            define_method "is_#{role}?" do
              self.role == role.to_s
            end
          end
        end
        
        class << self
          attr_accessor :wristband
        end
      end
      
      self.wristband = {
        :login_with_fields            => [options[:login_with]].flatten,
        :before_authentication_chain  => [options[:before_authentication]].flatten,
        :after_authentication_chain   => [options[:after_authentication]].flatten,
        :password_column              => options[:password_column],
        :plain_text_password          => options[:plain_text_password],
        :roles                        => options[:roles]
      }
      
      if options[:has_authorities]
        self.wristband[:authority_class] = UtilityMethods.interpret_class_specification(self, options[:has_authorities])
      end
    end    
  end
  
  module MigrationExtensions
    def create_users_table(options = { }, &block)
      case (options)
      when String:
        options = { :options => options }
      end
      
      create_table :users, options do |t|
        t.default_user_columns
        yield(t) if (block)
      end
    end
  end
  
  module TableDefinitionMethods
    def default_user_columns
      column :username, :string
      column :password_crypt, :string, :limit => 40
      column :password_salt, :string, :limit => 40
      column :remember_token, :string
      column :email_validation_key, :string
      column :created_at, :datetime
      column :updated_at, :datetime
    end
  end
  
  module UtilityMethods
    def self.interpret_class_specification(model_class, with_class)
      case (with_class)
      when Symbol:
        "#{model_class.class_name}#{with_class.to_s.camelcase}".constantize
      when String:
        with_class.constantize
      when true:
        "#{model_class.class_name}AuthorityCheck".constantize
      else
        with_class
      end
    end
  end

  
end
