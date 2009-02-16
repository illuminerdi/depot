require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  
  test "line_item has product and order" do
    order = orders(:one)
    product = products(:one)
    line_item = line_items(:one)
    # where to go from here?
  end
  
  test "from_cart_item creates a new line item" do
    cart_item = CartItem.new(products(:one))
    line_item = LineItem.from_cart_item(cart_item)
    assert line_item.valid?
    assert_equal products(:one), line_item.product
    assert_equal cart_item.quantity, line_item.quantity
    assert_equal cart_item.price, line_item.total_price.to_f / 100
  end
  
  test "from_cart_item with many of the same products" do
    product = products(:two)
    
    cart_item = CartItem.new(product)
    cart_item.increment_quantity
    cart_item.increment_quantity
    
    line_item = LineItem.from_cart_item(cart_item)
    
    assert_equal product, line_item.product
    assert_equal 3, line_item.quantity
    assert_equal cart_item.price, line_item.total_price.to_f / 100
  end
  
  test "line_item can has order" do
    line_item = line_items(:one)
    line_item.order = orders(:two)
    line_item.save!
    assert_equal orders(:two), line_item.order
  end
  
  test "line_item can has product" do
    line_item = line_items(:one)
    line_item.product = products(:two)
    line_item.save!
    assert_equal products(:two), line_item.product
  end
end
