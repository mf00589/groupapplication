class AddUserIdSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :user_id, :integer
    remove_column :submissions, :freelancerid, :integer
  end
end
