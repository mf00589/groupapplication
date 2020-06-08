class RemoveRankingSubmissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :submissions, :ranking
  end
end
