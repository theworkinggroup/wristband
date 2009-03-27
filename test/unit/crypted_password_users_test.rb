require File.join(File.dirname(__FILE__), '../test_helper')

class CryptedPasswordUser < ActiveRecord::Base
  wristband :roles => [:admin, :regular_user]
end


class CryptedPasswordUserTest < Test::Unit::TestCase
  fixtures :crypted_password_users
  
  def setup
    @scott = crypted_password_users(:scott)
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
      is_admin?
      is_regular_user?
    }.each do |method|
      assert @scott.respond_to?(method), "On '#{method}' method"
    end
  end

  def test_user_class_methods
    %w{
      authenticate
      execute_authentication_chain
      verify_email!
      wristband
    }.each do |method|
      assert CryptedPasswordUser.respond_to?(method), "On '#{method}' method"
    end
  end

  def test_user_class_private_methods
    %w{
      random_string
      encrypt_with_salt
      random_salt
    }.each do |method|
      assert CryptedPasswordUser.private_methods.include?(method), "On '#{method}' method"
    end
  end

  def test_assigned_options
    assert_equal CryptedPasswordUser.wristband[:login_with_fields], [:username]
    assert_equal CryptedPasswordUser.wristband[:plain_text_password], false
    assert_equal CryptedPasswordUser.wristband[:before_authentication_chain], []
    assert_equal CryptedPasswordUser.wristband[:after_authentication_chain], []
    assert_equal CryptedPasswordUser.wristband[:password_column], :password_crypt
    assert_equal CryptedPasswordUser.wristband[:roles], [:admin, :regular_user]
  end
  
  def test_authentication_by_username
    assert_equal @scott, CryptedPasswordUser.authenticate(@scott.username, @scott.password_crypt)
  end

  def test_authentication_fails
    assert_nil CryptedPasswordUser.authenticate('-bugus-', @scott.password_crypt)
    assert_nil CryptedPasswordUser.authenticate(@scott.email, '-bugus-')
  end
  
  def test_password_match
    assert @scott.password_match?(@scott.password_crypt)
    assert crypted_password_users(:jack).password_match?('passpass')
  end
  
  def test_user_roles
    assert crypted_password_users(:jack).is_regular_user?
    assert crypted_password_users(:scott).is_admin?
  end
  
end
