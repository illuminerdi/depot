class Order < ActiveRecord::Base
  has_many :line_items
  
  PAYMENT_TYPES = [
    ["Check", "check"],
    ["Credit card", "cc"],
    ["Purchase order", "po"]
  ]
  
  validates_presence_of :name, :address, :email, :pay_type
  validates_inclusion_of :pay_type, :in =>
    PAYMENT_TYPES.map {|disp,value| value}
end
