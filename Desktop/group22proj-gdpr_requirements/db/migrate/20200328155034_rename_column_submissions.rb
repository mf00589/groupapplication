class RenameColumnSubmissions < ActiveRecord::Migration[5.2]
  def change
    rename_column :submissions, :contestid, :contest_id
  end
end
