class CartItem
  attr_reader :quantity, :product
  
  def initialize(product)
    @product = product
    @quantity = 1
  end
  
  def increment_quantity
    @quantity += 1
  end
  
  def title
    @product.title
  end
  
  def price
    (@product.price * @quantity) / 100.0
  end
end