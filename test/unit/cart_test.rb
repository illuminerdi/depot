require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def test_initialize
    cart = Cart.new
    assert_equal 0, cart.items.length
  end
  
  def test_add_product
    cart = Cart.new
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
  end
  
  def test_chevron
    cart = Cart.new
    cart << products(:one)
    assert_equal 1, cart.items.length
  end
end