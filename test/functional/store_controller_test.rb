require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "session contains cart" do
    get :index
    assert session[:cart]
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title
      assert_match /#{sprintf("%01.2f", product.price / 100.0)}/, @response.body
      assert_tag :tag => 'input', :attributes => {
        :value => "Add to Cart",
        :type => "submit"
      }
      assert_tag :tag => 'form', :attributes => {
        :method => 'post'
      }
      assert_tag :tag => 'a'
    end
  end
  
  test "add_to_cart adds a product to the cart" do
    post :add_to_cart, :id => products(:one).id
    assert_redirected_to :action => :index
    assert cart = assigns(:cart)
    assert_equal 1, cart.items.length
  end
  
  test "add_to_cart adds a second of the same product and shows it to the user" do
    post :add_to_cart, :id => products(:one).id
    post :add_to_cart, :id => products(:one).id
    cart = assigns(:cart)
    assert_equal 2, cart.items[0].quantity
    assert_match /#{cart.items[0].quantity}&times;<\/td>\n\s+<td>#{products(:one).title}/, @response.body
  end
  
  test "add_to_cart protects against bad product ids being passed through url" do
    post :add_to_cart, :id => "tree"
    assert_redirected_to :controller => :store, :action => :index
    assert_equal "Invalid Product", flash[:notice]
  end
  
  test "add_to_cart works with ajaxy goodness" do
    xhr :post, :add_to_cart, :id => products(:one), :format => 'js'
    assert_response :success
  end
  
  test "empty_cart empties cart and redirects to index with status message" do
    post :empty_cart
    assert ! cart = assigns(:cart)
    assert_redirected_to :controller => :store, :action => :index
    assert_equal "Your cart is currently empty", flash[:notice]
  end
end
