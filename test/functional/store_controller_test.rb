require 'test_helper'
require 'yaml'

class StoreControllerTest < ActionController::TestCase
  test "session contains cart" do
    get :index
    assert session[:cart]
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    assert assigns(:cart).items.empty?
    assert_tag :tag => 'div', :attributes => {
      :id => 'cart',
      :style => 'display: none'
    }

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
    xhr :post, :add_to_cart, :id => products(:one), :format => 'js'
    assert_response :success
    assert cart = assigns(:cart)
    assert_template '_cart'
    assert_match /<td>#{products(:one).title}<\/td>/, @response.body
    assert_match /<tr id=\\\"current_item\\\"/, @response.body
  end
  
  test "add_to_cart adds a second of the same product and shows it to the user" do
    xhr :post, :add_to_cart, :id => products(:one), :format => 'js'
    xhr :post, :add_to_cart, :id => products(:one), :format => 'js'
    cart = assigns(:cart)
    assert_equal 1, cart.items.length
    assert_equal 2, cart.items[0].quantity
    assert_match /#{cart.items[0].quantity}&times;<\/td>\\n\s+<td>#{products(:one).title}/, @response.body
  end
  
  test "add_to_cart protects against bad product ids being passed through url" do
    xhr :post, :add_to_cart, :id => "tree", :format => 'js'
    assert_redirected_to :controller => :store, :action => :index
    assert_equal "Invalid Product", flash[:notice]
  end
  
  test "add_to_cart for no javascript degrades gracefully" do
    post :add_to_cart, :id => products(:one)
    assert_redirected_to :action => :index
  end
  
  test "empty_cart empties cart and redirects to index with status message" do
    post :empty_cart
    assert_nil assigns(:cart)
    assert_redirected_to :controller => :store, :action => :index
    assert flash[:notice] == "Your cart is now empty"
  end
  
  test "checkout does not allow empty cart" do
    @request.session[:cart] = Cart.new
    post :checkout
    assert_redirected_to :controller => :store, :action => :index
  end
  
  test "checkout form has all required fields" do
    @request.session[:cart] = Cart.new
    @request.session[:cart].add_product products(:one)
    post :checkout
    assert_response :success
    assert_tag :tag => 'input', :attributes => {:type => 'text', :name => 'order[name]'}
    assert_tag :tag => 'textarea', :attributes => {:name => 'order[address]'}
    assert_tag :tag => 'input', :attributes => {:type => 'text', :name => 'order[email]'}
    assert_tag :tag => 'select', :attributes => {:name => 'order[pay_type]'}
  end
  
  test "save_order empties cart and redirects to index with status message" do
    @request.session[:cart] = Cart.new
    @request.session[:cart].add_product(products(:one))

    post :save_order, :order => {
      :name => "Jay Graham",
      :address => "123 Silly St Federal Way, WA 98023",
      :email => "something.dumb@microsoft.com",
      :pay_type => "check"
    }
    assert_nil session[:cart]
    assert_redirected_to :controller => :store, :action => :index
  end
  
  test "save_order redirects to checkout when unable to save due to missing info" do
    post :save_order, :order => {
      :name => "", #=> bad!
      :address => "123 Silly St Federal Way, WA 98023",
      :email => "something.dumb@microsoft.com",
      :pay_type => "check"
    }
    assert_response :success
    order = assigns(:order)
    assert ! order.valid?
    assert_equal 1, order.errors.size
    error_msgs = order.errors.full_messages
    error_msgs.each do |error_msg|
      assert @response.body.include?(error_msg)
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert_equal 2, elements.size
    end
  end
  
  test "i18n stores in the session a supported locale" do
    get :index, :locale => "es"
    assert_response :success
    assert_equal "es", @response.session[:locale]
  end
  
  test "i18n fails when an unsupported locale is requested" do
    get :index, :locale => "goofy"
    assert_equal "en", @response.session[:locale]
    assert_response :success
    assert_equal "goofy translation not available", @response.flash[:notice]
    assert_match /goofy translation not available/, @response.body
  end
  
  test "i18n displays the requested locale output" do
    get :index, :locale => "es"
    assert_response :success
    
    expected = YAML.load_file( "#{LOCALES_DIRECTORY}es.yml" )["es"]
    
    assert_match expected["layout"]["side"]["home"], @response.body
    assert_match expected["layout"]["side"]["questions"], @response.body
    assert_match expected["layout"]["side"]["news"], @response.body
    assert_match expected["layout"]["side"]["contact"], @response.body
    assert_match expected["layout"]["title"], @response.body
  end
end
