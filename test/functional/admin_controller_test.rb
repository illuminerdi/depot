require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  
  test "user is able to successfully log in" do
    user = users(:one)
    post :login, :name => user.name, :password => 'boo'
    
    assert_redirected_to :controller => "admin", :action => "index"
    assert @response.session[:user_id]
  end
  
  test "user is unable to log in" do
    user = users(:one)
    post :login, :name => user.name, :password => 'foo'
    
    assert_response :success
    assert ! @response.session[:user_id]
    assert_match /Invalid user\/password combination/, @response.body
  end
  
  test "user is redirected once authenticated" do
    @request.session[:original_uri] = users_path
    user = users(:one)
    post :login, :name => user.name, :password => 'boo'
    
    assert_redirected_to users_path
  end
end
