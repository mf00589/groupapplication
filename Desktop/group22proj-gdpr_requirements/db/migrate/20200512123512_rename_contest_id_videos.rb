class RenameContestIdVideos < ActiveRecord::Migration[5.2]
  def change
    rename_column :videos, :contestid, :contest_id
  end
end
