class AddUserIdToRecipients < ActiveRecord::Migration[5.2]
  def change
    add_column :recipients, :user_id, :integer
  end
end
