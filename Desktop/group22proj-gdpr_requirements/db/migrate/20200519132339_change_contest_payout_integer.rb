class ChangeContestPayoutInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :contests, :payout_amount, :integer
  end
end
