class CreateOrderRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :order_recipients do |t|
      t.integer :order_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
