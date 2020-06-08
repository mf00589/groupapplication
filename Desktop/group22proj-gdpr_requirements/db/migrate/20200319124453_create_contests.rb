class CreateContests < ActiveRecord::Migration[5.2]
  def change
    create_table :contests do |t|
      t.string :name
      t.integer :vendorid
      t.text :description
      t.string :category
      t.float :payout_amount
      t.datetime :start_date
      t.datetime :ending_date
      t.boolean :is_student_only
      t.string :youtube_link
      t.string :skills

      t.timestamps
    end
  end
end
