# = AuthorityCheck
# The different user authorities are defined in a separate class so as to reduce
# clutter in the User model itself. 
# 
#   class User < ActiveRecord::Base
#     wristband :has_authorities => true
#   end
#   
# This will refer to the class UserAuthorityCheck for all authority tests, but the
# name of this module can be defined as required:
# 
#   class User < ActiveRecord::Base
#     has_authorities => :permissions
#   end
# 
# That would reference the class UserPermissions instead for all tests.
# 
# A sample authority checking class is defined as:
# 
#   class UserAuthorityCheck < AuthorityCheck
#     def wear_shoes?
#       unless (@user.name.match(/^a/i))
#         fail!("Only people with names that start with 'A' can wear shoes.")
#       end
#     end
#   end
# 
# <b>Note the syntax: </b>All authority checks are defined as ending with a trailing question mark
# character.
# 
# A check is considered to have passed if
# * a call to <tt>allow!</tt> has been made, or
# * no calls to <tt>fail!</tt> have been made.
# 
# Once defined, the user authorities are checked via a call to a User instance:
# 
#   user.has_authority_to?(:wear_shoes)
# 
# While the <tt>has_authority_to?</tt> method returns only true or false, a call to
# <tt>has_objections_to?</tt> will return nil on success or any error messages if there
# is a failure.
# 
# 
# ==== Passing parameters to the authority methods
# 
# Any call to these tests may include options in the form of a Hash:
# 
#   user.has_authority_to?(:send_message, :text => "Foo bar")
#   
# These options can be acted upon within the authority check:
# 
#   def send_message?
#     if (options[:text].match(/foo/i))
#       fail!("Messages may not contain forbidden words.")
#     end
#   end
# 
# ==== Before chains
# 
# In addition to defining straight tests, a chain can be defined to run before
# any of the tests themselves. This allows certain calls to be over-ruled. For
# example:
# 
#   before_check :allow_if_admin!
#   
#   def allow_if_admin!
#     if (@user.is_admin?)
#       allow!
#     end
#   end
#   
# In this case, the <tt>allow_if_admin!</tt> method will be called before any checks are performed. If
# the <tt>allow!</tt> method is executed, all subsequent tests are halted and the check
# is considered to have passed.

class AuthorityCheck
  attr_accessor :user
  attr_accessor :options
  
  def initialize(user, test_method, options = { })
    self.user = user
    self.options = options
    
    @test_method = "#{test_method}?".to_sym

    @result = nil
  end
  
  # Checkes if the user is allowed to do something.
  # Returns <tt>true</tt> or <tt>false</tt>
  def allowed_to?
    execute_tests!

    # Either explicitly allowed (true) or not given any reasons as to why
    # not (nil, empty)
    (@result === true or (@result === nil and @reasons.blank?)) ? true : false
  end
  
  def denied_for_reasons
    @reasons = [ ]
    
    allowed_to? ? nil : @reasons
  end
  
  
  class << self
    def check_chain
      @check_chain ||= [ ]
    end

    def check_chain=(value)
      @check_chain = value
    end
  
    def before_check(method, options = { })
      self.check_chain += remap_chain_methods([ method ])
    end
  
    def check_alias_as(original, *aliases)
      aliases.flatten.each do |alias_name|
        alias_method alias_name, original
      end
    end
  end


  
protected
  def allow!
    @result = true
  end
  
  def fail!(message)
    if (@reasons and message)
      @reasons << message
    end
    
    @result = false
  end

  def execute_tests!
    self.class.check_chain.each do |method|
      case (method)
      when Symbol, String:
        send(method)
      else
        method.call
      end

      # Stop evaluating if this test called allow!
      return if (@result === true)
    end
    
    self.send(@test_method)
  end

  def self.remap_chain_methods(methods)
    methods
  end
end
