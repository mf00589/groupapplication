class ChangeDataTypePrizes < ActiveRecord::Migration[5.2]
  def change
    change_column :contests, :first_prize, :float
    change_column :contests, :second_prize, :float
    change_column :contests, :third_prize, :float
  end
end
