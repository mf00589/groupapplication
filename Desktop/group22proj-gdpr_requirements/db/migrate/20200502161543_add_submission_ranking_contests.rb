class AddSubmissionRankingContests < ActiveRecord::Migration[5.2]
  def change
    add_column :contests, :first_place, :integer
    add_column :contests, :second_place, :integer
    add_column :contests, :third_place, :integer
  end
end
