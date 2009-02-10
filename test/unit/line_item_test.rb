require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  
  test "line_item has product and order" do
    order = orders(:one)
    product = products(:one)
    line_item = line_items(:one)
    # where to go from here?
  end
end
