require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    assert_tag :tag => 'span', :attributes => {
      :class => 'price'
    }
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[title]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'product[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[image_url]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[price]'
    }
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => {
        :title        => 'awesome product',
        :description  => 'awesome product description',
        :image_url    => 'http://example.com/foo.gif',
        :price        => '100'
      }
    end

    assert_redirected_to product_path(assigns(:product))
  end
  
  test "does not redirect on error for new product" do
    post :create, :product => {
      :title        => 'awesome product',
      :description  => 'awesome product description',
      :image_url    => 'http://example.com/foo.gif',
      :price        => 'abc' # bad price!
    }
    
    assert_response :success # 200 is okay, we're coming back to the same page, no redirect, because we broke the model
  end
  
  test "should convert decimal price to integer amount of pennies for new product" do
    post :create, :product => {
      :title        => 'some other awesome product',
      :description  => 'some other awesome product description',
      :image_url    => '/images/svn.png',
      :price        => '20.95'
    }
    
    product = assigns(:product)
    assert product.valid?
    assert product.price == 2095, :message => ": 2095 expected, #{product.price} returned instead"
  end
  
  test "should show errors on bad new product" do
    post :create, :product => {
      :title        => 'some other awesome product',
      :description  => '', # bad, expecting to contain something
      :image_url    => '/images/svn.png',
      :price        => 'abc' # not a number.
    }
    product = assigns(:product)
    assert ! product.valid?, :message => ": Product is valid (and shouldn't be)"
    assert product.errors.size == 3, :message => ": Wrong number of error messages from model"
    error_msgs = product.errors.full_messages
    # search the body for our error message
    error_msgs.each do |error_msg|
      assert @response.body.include?(error_msg), 
        :message => ": Error message not found in response body"
    end
    assert_select "div.fieldWithErrors" do |elements|
      assert elements.size == 4, :message => ": Wrong number of fields showing errors on page"
    end
  end

  test "should show product" do
    get :show, :id => products(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => products(:one).id
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[title]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'product[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[image_url]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[price]'
    }
    assert_response :success
  end

  test "should update product" do
    put :update, :id => products(:one).id, :product => {
      :title => 'mega awesome title'
    }
    assert_redirected_to product_path(assigns(:product))

    assert_equal 'mega awesome title', Product.find(products(:one).id).title
  end
  
  test "should not redirect on error for updated product" do
    put :update, :id => products(:one).id, :product => {
      :title => 'foo'
    }
    
    assert_response :success # 200 is okay, we're coming back to the same page, no redirect, because we broke the model
  end
  
  test "should show errors on bad product update" do
    put :update, :id => products(:one).id, :product => {
      :title => 'foo'
    }
    
    product = assigns(:product)
    assert ! product.valid?, :message => ": Product is valid (and shouldn't be)"
    assert product.errors.size == 1, :message => ": Wrong number of error messages from model"
    error_msg = product.errors.full_messages.first
    # search the body for our error message
    assert @response.body.include?(error_msg), 
        :message => ": Error message not found in response body"
    assert_select "div.fieldWithErrors" do |elements|
      assert elements.size == 2, :message => ": Wrong number of fields showing errors on page"
    end
  end
  
  test "should convert decimal price to integer amount of pennies for product update" do
    put :update, :id => products(:one).id, :product => {
      :price => '124.2'
    }
    
    product = assigns(:product)
    assert product.valid?
    assert product.price = 12420
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => products(:one).id
    end

    assert_redirected_to products_path
  end
end
