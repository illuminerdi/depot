class InfoController < ApplicationController
  def who_bought
    @product = Product.find(params[:id])
    @orders = @product.orders
    
    respond_to do |format|
      format.xml { render :layout => false }
    end
  end

end
