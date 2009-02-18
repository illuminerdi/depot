require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  
  test "who_bought works for xml info" do
    get :who_bought, :id => products(:one).id
    product = assigns(:product)
    
    assert_response :success
    assert_match /<title>#{product.title}<\/title>/, @response.body
    assert_match /<description>#{product.description}/, @response.body
    assert_match /<name>#{product.orders.first.name}<\/name>/, @response.body
    assert_match /<address>#{product.orders.first.address}/, @response.body
  end
  
  test "who_bought works for json info" do
    get :who_bought, :id => products(:one).id, :format => "json"
    product = assigns(:product)
    
    assert_response :success
    response = ActiveSupport::JSON.decode(@response.body)
    assert_equal product.title, response["product"]["title"]
    assert_equal product.price, response["product"]["price"]
    assert_equal product.orders.first.email, response["product"]["orders"].first["email"]
    assert_equal product.orders.first.pay_type, response["product"]["orders"].first["pay_type"]
  end

  test "who_bought with unknown product for xml gives helpful error" do
    get :who_bought, :id => -1
    
    assert_response :success
    assert_match /<message>Couldn't find Product with ID=-1<\/message>/, @response.body
  end
  
  test "who_bought with unknown product for JSON gives helpful error" do
    get :who_bought, :id => -1, :format => "json"
    
    assert_response :success
    response = ActiveSupport::JSON.decode(@response.body)
    assert_equal "Couldn't find Product with ID=-1", response["message"]
  end
  
  test "who_bought handles a product that has no orders" do
    LineItem.update(line_items(:one).id, :product_id => products(:two).id)
    get :who_bought, :id => products(:one)
    
    assert_response :success
    assert_match /<orders.+\/>/, @response.body
  end
end
