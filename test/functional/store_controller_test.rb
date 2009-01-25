require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title
      assert_match /#{sprintf("%01.2f", product.price / 100)}/, @response.body
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
end
