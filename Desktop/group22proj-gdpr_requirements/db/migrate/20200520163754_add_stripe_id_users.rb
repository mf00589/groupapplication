class AddStripeIdUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :stripe_id, :string
  end
end
