class CreateAccountPermissions < ActiveRecord::Migration
  def change
    create_table :account_permissions do |t|
      t.integer :account_id
      t.column  :account_role, "enum('manager')", default: "manager"
      t.boolean :read_accounts, default: true
      t.boolean :manage_accounts, default: true
      t.boolean :read_wallets, default: true
      t.boolean :read_verifications, default: true
      t.boolean :manage_verifications, default: true
      t.boolean :read_locations, default: true
      t.boolean :manage_locations, default: true
    end
  end
end
