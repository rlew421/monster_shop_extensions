class Admin::DashboardController < Admin::BaseController
  def show
    @user = User.find(session[:user_id])
    @packaged = Order.where(status: 'packaged')
    @pending = Order.where(status: 'pending')
    @cancelled = Order.where(status: 'cancelled')
    @shipped = Order.where(status: 'shipped')
  end
end
