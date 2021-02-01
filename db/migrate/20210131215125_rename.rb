class Rename < ActiveRecord::Migration[5.2]
  def change
  	rename_column :gifts, :type, :gift_type
  end
end
