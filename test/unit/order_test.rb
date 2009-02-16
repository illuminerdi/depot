require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  test "order has an address" do
    order = orders(:one)
    order.address = "325 Erisian Ave, New Orleans, LA 70121"
    assert order.save!
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
  
  test "order validates presence of pay type" do
    order = orders(:two)
    order.pay_type = ""
    assert ! order.valid?
    assert order.errors.on(:pay_type)
  end
  
  test "unknown pay type throws an error" do
    order = orders(:one)
    order.pay_type = "monopoly money"
    assert ! order.valid?
    assert order.errors.on(:pay_type)
  end
  
  test "add a line item" do
    order = Order.new(
      :name => "jgc",
      :address => "asdfasdf",
      :email => "asdf@asdf.com",
      :pay_type => "cc"
    )
    cart = Cart.new
    cart.add_product(products(:one))
    order.add_line_items_from_cart(cart)
    assert_equal 1, order.line_items.size
  end
  
  test "order has at least one product in it" do
    order = orders(:one)
    line_item = line_items(:one)
    product = products(:one)
    assert_equal order, product.line_items.first.order
    assert_equal product, order.products.first
  end
end
