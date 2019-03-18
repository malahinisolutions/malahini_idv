class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.integer :account_id
      t.string :username
      t.string :password

      t.timestamps null: false
    end
  end
end
