class AddStatusToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_column :merchants, :status, :string, default: 'enabled'
  end
end
