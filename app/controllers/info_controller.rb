class InfoController < ApplicationController
  def who_bought
    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.xml { render :layout => false, :xml => @product.to_xml(:include => :orders) }
      format.json { render :layout => false, :json => @product.to_json(:include => :orders )}
    end
  end

  private
  
  def authorize
    
  end

end
