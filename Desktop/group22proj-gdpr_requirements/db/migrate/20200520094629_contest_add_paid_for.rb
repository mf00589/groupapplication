class ContestAddPaidFor < ActiveRecord::Migration[5.2]
  def up
    add_column :contests, :paid_for, :boolean, default: false
  end

  def down
    remove_column :contests, :paid_for, :boolean, default: false
  end
end
