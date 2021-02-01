class AddDeliveriesToSchools < ActiveRecord::Migration[5.2]
  def change
    add_column :schools, :deliveries, :integer
  end
end
