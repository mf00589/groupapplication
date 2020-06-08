class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.integer :submissionid
      t.integer :rating
      t.text :description

      t.timestamps
    end
  end
end
