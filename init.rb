require 'wristband'

ActiveRecord::Base.send(:extend, Wristband::ClassMethods)
ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Wristband::TableDefinitionMethods)
ActionController::Base.send(:include, Wristband::ApplicationExtensions)

class UserVerificationError < StandardError; end
