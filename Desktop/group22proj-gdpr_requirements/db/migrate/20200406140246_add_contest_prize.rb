class AddContestPrize < ActiveRecord::Migration[5.2]
  def change
    add_column :contests, :first_prize, :integer
    add_column :contests, :second_prize, :integer
    add_column :contests, :third_prize, :integer
  end
end
