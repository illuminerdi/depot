require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @request.session[:user_id] = users(:one).id
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[password]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[password_confirmation]'
    }
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => {
        :name => "hugh",
        :password => "grant",
        :password_confirmation => "grant"
      }
    end

    assert_redirected_to users_path()
  end

  test "should show user" do
    get :show, :id => users(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => users(:one).id
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[password]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[password_confirmation]'
    }
  end

  test "should update user" do
    put :update, :id => users(:one).id, :user => {
      :password => "funny",
      :password_confirmation => "funny"
    }
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:one).id
    end

    assert_redirected_to users_path
    assert_equal @response.flash[:notice], "User #{users(:one).name} deleted"
  end
  
  test "should not destroy the last user" do
    users = User.find(:all)
    assert_raise(RuntimeError) do
      loop do
        users.first.destroy
        users.shift
      end
    end

   assert_equal 1, users.length
  end
end
