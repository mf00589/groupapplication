class ChangeContestPrizesInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :contests, :first_prize, :integer
    change_column :contests, :second_prize, :integer
    change_column :contests, :third_prize, :integer
  end
end
