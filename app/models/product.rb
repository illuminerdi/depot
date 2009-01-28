class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url
  validates_uniqueness_of :title
  validates_numericality_of :price,
                      :message => 'must be an amount of pennies'
  validate :price_must_be_at_least_a_cent
  validates_format_of :image_url, 
                      :with => %r{\.(gif|jpg|png)$}i, 
                      :message => 'must be a URL for GIF, JPG ' + 
                      'or PNG image.(gif|jpg|png)'
  validates_length_of :title,
                      :minimum => 10,
                      :message => "seems too short (must be at least 10 characters long)"

  def self.find_products_for_sale
    find(:all, :order => "title")
  end
  
  def price=(new_price)
    if new_price.instance_of?(Fixnum) or new_price.instance_of?(Float) or new_price == new_price.to_f.to_s
      new_price = (new_price.to_f * 100.0).round
    end
    write_attribute(:price, new_price)
  end
  
  protected
  
  def price_must_be_at_least_a_cent
    errors.add(:price, 'should be at least 0.01') if price.nil? || price < 1
  end
end
