class Merchant::ItemOrdersController < Merchant::BaseController

  def fulfill
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.fulfill
    flash[:success] = "#{item_order.item.name} has been fulfilled."
  
    redirect_to "/merchant/orders/#{item_order.order_id}"
  end


end
