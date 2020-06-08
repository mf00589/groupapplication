class AddUserIdContests < ActiveRecord::Migration[5.2]
  def change
    add_column :contests, :user_id, :integer
    remove_column :contests, :vendorid
  end
end
