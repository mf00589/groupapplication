class AddDefaultContestsWonUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :contests_won, false
    change_column_default :users, :contests_won, 0
    change_column_null :users, :contests_entered, false
    change_column_default :users, :contests_entered, 0
  end
end
