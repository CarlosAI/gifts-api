class Remove < ActiveRecord::Migration[5.2]
  def change
  	remove_column :orders, :recipient_id, :integer
  	remove_column :orders, :gift_type, :string
  	remove_column :schools, :deliveries, :integer
  end
end
