class ChangeTableAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :encrypted_password, :string, default: ""
    add_column :accounts, :email, :string, default: ""
    add_column :accounts, :phone_number, :string, default: ""
  end

  def self.down
    remove_column :accounts, :encrypted_password
    remove_column :accounts, :email
    remove_column :accounts, :phone_number
  end
end
