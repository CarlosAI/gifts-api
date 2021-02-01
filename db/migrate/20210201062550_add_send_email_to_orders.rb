class AddSendEmailToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :send_email, :boolean
  end
end
