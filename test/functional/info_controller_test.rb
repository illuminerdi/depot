require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  
  test "who_bought works for xml info" do
    get :who_bought, :id => products(:one).id
    product = assigns(:product)
    orders = assigns(:orders)
    
    assert_response :success
    assert_match /<title>Foo is the first book<\/title>/, @response.body
    assert_match /<name>Joshua Clingenpeel<\/name>/, @response.body
    assert_match /<address>123 Happy Road, Seattle WA 98101/, @response.body
    assert_match /<description>A quick book for testing stuff!/, @response.body
  end

end
