class Merchant::DashboardController < Merchant::BaseController

  def show
    @merchant = Merchant.find(current_user.merchant_id)
    order_ids = Order.joins(:items).where("items.merchant_id = #{@merchant.id}").pluck(:id)
    @orders = Order.find(order_ids)
  end
  
end
