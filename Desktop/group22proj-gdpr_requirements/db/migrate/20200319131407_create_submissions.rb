class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.integer :freelancerid
      t.integer :contestid
      t.integer :ranking
      t.float :share_of_price

      t.timestamps
    end
  end
end
