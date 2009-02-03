class Cart
  attr_reader :items
  
  def initialize
    @items = []
  end
  
  def add_product(product)
    @items << product
  end
  alias :<< :add_product
end