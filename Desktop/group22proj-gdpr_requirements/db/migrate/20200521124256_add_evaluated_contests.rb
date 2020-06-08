class AddEvaluatedContests < ActiveRecord::Migration[5.2]
  def up
    add_column :contests, :evaluated, :boolean, default: false
  end

  def down
    remove_column :contests, :evaluated, :boolean, default: false
  end
end
