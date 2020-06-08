class DropLikesFeedbackTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :likes
    drop_table :feedbacks
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
