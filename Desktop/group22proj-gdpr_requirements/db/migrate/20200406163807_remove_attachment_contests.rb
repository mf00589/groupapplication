class RemoveAttachmentContests < ActiveRecord::Migration[5.2]
  def change
    remove_column :contests, :attachment

  end
end
