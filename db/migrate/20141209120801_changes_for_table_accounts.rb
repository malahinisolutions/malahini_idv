class ChangesForTableAccounts < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :admin
    remove_column :accounts, :password
    add_column :accounts, :encrypted_password, :string, default: ""
  end

  def self.down
    add_column :accounts, :admin, :boolean
    add_column :accounts, :password, :string
    remove_column :accounts, :encrypted_password
  end
end
