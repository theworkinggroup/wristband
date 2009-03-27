require File.join(File.dirname(__FILE__), '../test_helper')

class UserAuthorityCheck < AuthorityCheck
  before_check :is_admin?
  
  def is_admin?
    unless (@user.username.match(/^scott/i))
      fail!("Only scott can be an admin.")
    else
      allow!
    end    
  end
  
  def wear_shoes?
    unless (@user.username.match(/^s/i))
      fail!("Only people with names that start with 'S' can wear shoes.")
    end
  end

  def walk_outside?
    wear_shoes?
    unless (@user.username.match(/^j/i))
      fail!("Only people with names that start with 'J' or 'S' can walk outside.")
    end
  end
  
end

class User < ActiveRecord::Base
  wristband :has_authorities => true
end


class HasAuthoritiesTest < Test::Unit::TestCase
  fixtures :users

  def test_has_authority_to_with_fail
    assert users(:scott).has_authority_to?(:wear_shoes)
    assert !users(:jack).has_authority_to?(:wear_shoes)
    assert_equal users(:jack).has_objections_to?(:wear_shoes), ["Only scott can be an admin.", "Only people with names that start with 'S' can wear shoes."]


    assert users(:scott).has_authority_to?(:walk_outside)
    assert !users(:jack).has_authority_to?(:walk_outside)
    assert_equal users(:jack).has_objections_to?(:walk_outside), ["Only scott can be an admin.", "Only people with names that start with 'S' can wear shoes."]
    assert !users(:oleg).has_authority_to?(:walk_outside)
    assert_equal users(:oleg).has_objections_to?(:walk_outside), ["Only scott can be an admin.", "Only people with names that start with 'S' can wear shoes.", "Only people with names that start with 'J' or 'S' can walk outside."]
  end
end
