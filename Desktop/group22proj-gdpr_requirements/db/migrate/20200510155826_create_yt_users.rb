class CreateYtUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :yt_users do |t|
      t.string :name
      t.string :token
      t.string :uid

      t.timestamps
    end
    add_index :yt_users, :uid, unique: true
  end
end
