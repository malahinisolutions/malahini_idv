class CreateApiAccounts < ActiveRecord::Migration
  def change
    create_table :api_accounts do |t|
      t.integer :account_id
      t.integer :server_pubkey_id
      t.string  :client_pubkey

      t.timestamps
    end
  end
end
