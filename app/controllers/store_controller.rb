class StoreController < ApplicationController
  def index
    find_cart
    @products = Product.find_products_for_sale
  end
  
  def add_to_cart
    @cart = find_cart
    product = Product.find(params[:id])
    @cart << product
  end

  private
  
  def find_cart
    session[:cart] ||= Cart.new
  end
end
