class RemoveUserRatingUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column(:users, :user_rating)
  end
  def down
    add_column(:users, :user_rating, :float)
  end
end
