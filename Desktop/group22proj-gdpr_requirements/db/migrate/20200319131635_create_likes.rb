class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :submissionid
      t.integer :userid

      t.timestamps
    end
  end
end
