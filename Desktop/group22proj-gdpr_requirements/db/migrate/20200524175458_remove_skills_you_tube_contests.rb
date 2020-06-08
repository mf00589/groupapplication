class RemoveSkillsYouTubeContests < ActiveRecord::Migration[5.2]
  def change
    change_column :contests, :payout_amount, :integer, default: 0
    remove_column :contests, :youtube_link
    remove_column :contests, :skills
  end
end
