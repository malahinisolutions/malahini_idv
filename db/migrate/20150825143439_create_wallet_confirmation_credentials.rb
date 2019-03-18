class CreateWalletConfirmationCredentials < ActiveRecord::Migration
  def change
    create_table :wallet_confirmation_credentials do |t|
      t.integer :account_id
      t.string :login
      t.string :password
      t.string :token
      t.datetime :confirmed_at

      t.timestamps null: false
    end
  end
end
