class Admin::MerchantsController < Admin::BaseController

  def show
    @merchant = Merchant.find(params[:merchant_id])
    order_ids = Order.joins(:items).where("items.merchant_id = #{@merchant.id}").pluck(:id)
    @orders = Order.find(order_ids)
  end

  def update_status
    merchant = Merchant.find(params[:merchant_id])
    if !merchant.enabled?
      merchant.enable
      merchant.items.each do |item|
        item.activate
      end
      flash[:success] = "#{merchant.name} is now enabled."
    elsif merchant.enabled?
      merchant.disable
      merchant.items.each do |item|
        item.deactivate
      end
      flash[:success] = "#{merchant.name} is now disabled."
    end
    redirect_to '/merchants'
  end
end
