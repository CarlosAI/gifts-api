class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :gift_type
      t.integer :recipient_id
      t.integer :school_id

      t.timestamps
    end
  end
end
