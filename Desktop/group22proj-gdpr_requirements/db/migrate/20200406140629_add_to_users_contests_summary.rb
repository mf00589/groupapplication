class AddToUsersContestsSummary < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :contests_won, :integer
    add_column :users, :contests_entered, :integer
  end
end
