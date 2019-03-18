class AddColumnsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :first_name, :string
    add_column :accounts, :last_name, :string
    add_column :accounts, :active, :boolean, default: true 
  end

  def self.down
    remove_column :accounts, :first_name
    remove_column :accounts, :last_name
    remove_column :accounts, :active
  end
end
