class DifferentiateUserAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_student, :boolean
    add_column :users, :user_rating, :float
    add_column :users, :is_freelancer, :boolean


  end
end
