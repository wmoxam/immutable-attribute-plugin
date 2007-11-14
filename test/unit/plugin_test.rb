require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class EnsuresImmutabilityOfTest < Test::Unit::TestCase
  fixtures :accounts

  def test_set_on_creation
    account = nil
    assert_nothing_thrown do
      account = Account.create(:username => 'jgreen')
    end
    assert account.valid?
    assert account.username == 'jgreen'
  end

  def test_assignment_if_nil
    account = accounts(:nil_account)
    assert_nothing_thrown do
      account.username = 'jgreen'
    end
    assert account.save
  end

  def test_error_on_assignment
    account = accounts(:wmoxam)
    assert_raise RuntimeError do
      account.username = 'jgreen'
    end
  end

  def test_error_on_update
    account = accounts(:wmoxam)
    assert_raise RuntimeError do
      account.update_attributes(:username => 'jgreen')
    end
  end
end
