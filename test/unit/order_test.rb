require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  test "order has an address" do
    order = orders(:one)
    order.address = "325 Erisian Ave, New Orleans, LA 70121"
    assert order.save!
  end
end
