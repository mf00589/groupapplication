class AddContestidToVideos < ActiveRecord::Migration[5.2]
  def up
    add_column :videos, :contestid, :integer
  end

  def down
    remove_column :videos, :contestid, :integer
  end
end
