require 'test_helper'

class CartTest < ActiveSupport::TestCase
  def test_initialize
    cart = Cart.new
    assert_equal 0, cart.items.length
  end
  
  def test_add_new_product
    cart = Cart.new
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
  end
  
  def test_add_more_than_one_product
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:two)
    assert_equal 2, cart.items.length
    assert cart.items[0].product.title != cart.items[1].product.title
  end
  
  def test_chevron
    cart = Cart.new
    cart << products(:one)
    assert_equal 1, cart.items.length
  end
  
  def test_increment_existing_product_in_cart
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
    assert_equal 2, cart.items[0].quantity
  end
  
  def test_total_price
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:two)
    cart.add_product products(:two)
    assert_equal 4940, cart.total_price
  end
end