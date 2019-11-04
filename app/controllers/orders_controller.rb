class OrdersController <ApplicationController

  def index
    @orders = Order.where(user_id: session[:user_id]).joins(:user).where("users.is_active = true")
  end

  def new
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price,
          merchant: item.merchant
          })
      end
      cart.items.each do |item, quantity|
        new_quantity = item.inventory - quantity
        item.update_attributes(:inventory => new_quantity)
      end
      session.delete(:cart)
      flash[:success] = 'Your order has been placed!'
      redirect_to "/profile/orders/#{order.id}"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def destroy
    order = Order.find(params[:order_id])
    order.update_attributes(:status => 'cancelled')

    order.item_orders.each do |item_order|
      item_order.update_attributes(:status => 0)

      item = Item.find(item_order.item_id)
      new_quantity = item.inventory + item_order.quantity
      item.update_attributes(:inventory => new_quantity)
    end

    flash[:success] = 'Your order has been cancelled.'
    redirect_to "/profile/#{session[:user_id]}"
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
