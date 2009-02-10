require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  test "order has an address" do
    order = orders(:one)
    order.address = "325 Erisian Ave, New Orleans, LA 70121"
    assert order.save!
  end
  
  test "unknown pay type throws an error" do
    order = orders(:one)
    order.pay_type = "monopoly money"
    assert ! order.valid?
    assert order.errors.on(:pay_type)
  end
  
  test "order validates presence of name" do
    order = orders(:one)
    order.name = ""
    assert ! order.valid?
    assert order.errors.on(:name)
  end
  
  test "order validates presence of address" do
    order = orders(:one)
    order.address = ""
    assert ! order.valid?
    assert order.errors.on(:address)
  end
  
  test "order validates presence of email" do
    order = orders(:one)
    order.email = ""
    assert ! order.valid?
    assert order.errors.on(:email)
  end
end
