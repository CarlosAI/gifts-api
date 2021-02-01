class CreateRecipients < ActiveRecord::Migration[5.2]
  def change
    create_table :recipients do |t|
      t.string :name
      t.string :address
      t.integer :school_id

      t.timestamps
    end
  end
end
