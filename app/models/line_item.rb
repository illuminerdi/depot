class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  def self.from_cart_item(cart_item)
    li = self.new
    li.product = cart_item.product
    li.quantity = cart_item.quantity
    li.total_price = cart_item.price
    li
  end
  
  def total_price=(new_price)
    new_price = (new_price.to_f * 100.0).round
    write_attribute(:total_price, new_price)
  end
end
