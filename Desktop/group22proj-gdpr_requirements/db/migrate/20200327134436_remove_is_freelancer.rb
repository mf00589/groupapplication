class RemoveIsFreelancer < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :is_freelancer

  end
end
