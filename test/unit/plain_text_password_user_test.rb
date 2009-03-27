require File.join(File.dirname(__FILE__), '../test_helper')

class PlainTextPasswordUser < ActiveRecord::Base
  wristband :login_with => [:username, :email], 
            :plain_text_password => true,
            :after_authentication => :email_is_verified?,
            :password_column => :password

  def email_is_verified?
    return self.email_validation_key.blank?
  end
end



class PlainTextPasswordUserTest < Test::Unit::TestCase
  fixtures :plain_text_password_users
  
  def setup
    @jack = plain_text_password_users(:jack)
  end

  def test_user_instance_methods
    %w{
      has_authority_to?
      has_objections_to?
      initialize_salt
      initialize_token
      encrypt_password
      password_match?
      password_crypted?
      password_crypt=
    }.each do |method|
      assert @jack.respond_to?(method), "On '#{method}' method"
    end
  end

  def test_user_class_methods
    %w{
      authenticate
      execute_authentication_chain
      verify_email!
      wristband
    }.each do |method|
      assert PlainTextPasswordUser.respond_to?(method), "On '#{method}' method"
    end
  end

  def test_user_class_private_methods
    %w{
      random_string
      encrypt_with_salt
      random_salt
    }.each do |method|
      assert PlainTextPasswordUser.private_methods.include?(method), "On '#{method}' method"
    end
  end

  def test_assigned_options    
    assert_equal PlainTextPasswordUser.wristband[:login_with_fields], [:username, :email]
    assert_equal PlainTextPasswordUser.wristband[:plain_text_password], true
    assert_equal PlainTextPasswordUser.wristband[:before_authentication_chain], []
    assert_equal PlainTextPasswordUser.wristband[:after_authentication_chain], [:email_is_verified?]
    assert_equal PlainTextPasswordUser.wristband[:password_column], :password
    assert_equal PlainTextPasswordUser.wristband[:roles], []
  end
  
  def test_authentication_by_username
    assert_equal @jack, PlainTextPasswordUser.authenticate(@jack.username, @jack.password)
  end

  def test_authentication_by_email
    assert_equal @jack, PlainTextPasswordUser.authenticate(@jack.email, @jack.password)
  end

  def test_authentication_fails
    assert_nil PlainTextPasswordUser.authenticate('-bugus-', @jack.password)
    assert_nil PlainTextPasswordUser.authenticate(@jack.email, '-bugus-')
  end

  def test_after_authentication_chain
    @jack.update_attribute(:email_validation_key, Time.now)
    assert_nil PlainTextPasswordUser.authenticate(@jack.username, @jack.password)

    @jack.update_attribute(:email_validation_key, nil)
    assert_equal @jack, PlainTextPasswordUser.authenticate(@jack.username, @jack.password)
  end
  
  def test_password_match
    assert @jack.password_match?(@jack.password)
  end
end
