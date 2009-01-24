require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product has price" do
    product = products(:one)
    product.price = 1000
    product.save!
  end

  test "product validates presence of title" do
    product = Product.new
    assert ! product.valid?
    assert product.errors.on(:title)
  end

  test "product validates presence of description" do
    product = Product.new
    assert ! product.valid?
    assert product.errors.on(:description)
  end

  test "product validates presence of url" do
    product = Product.new
    assert ! product.valid?
    assert product.errors.on(:image_url)
  end

  test "that price must be a number" do
    product = products(:one)
    product.price = 'hello world!'
    assert ! product.valid?
    assert product.errors.on(:price)
  end

  test "that the price must be at least one cent" do
    product = products(:one)

    product.price = 0.01
    assert !product.valid?
    assert product.errors.on(:price)

    product.price = nil
    assert !product.valid?
    assert product.errors.on(:price)

    product.price = 1
    assert product.save!
  end

  test "that titles are unique" do
    product = Product.new(products(:one).attributes)
    assert ! product.valid?
    assert product.errors.on(:title)
  end

  test "urls must be formatted properly" do
    product = products(:one)
    assert product.valid?
    product.image_url = 'http://asdfasdfadsf'
    assert ! product.valid?
    assert product.errors.on(:image_url)
  end

  test "find_products_for_sale" do
    sale_products = Product.find_products_for_sale
    assert sale_products
    assert_equal Product.find(:all).sort_by { |product|
      product.title
    }, sale_products
  end
end
