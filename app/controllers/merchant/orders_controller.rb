class Merchant::OrdersController < Merchant::BaseController


  def show
    @order = Order.find(params[:order_id])
    @user = User.find(@order.user_id)
    @item_orders = @order.item_orders.where("item_orders.merchant_id = #{current_user.merchant_id}")
  end


end
