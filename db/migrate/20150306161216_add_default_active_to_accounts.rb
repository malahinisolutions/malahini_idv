class AddDefaultActiveToAccounts < ActiveRecord::Migration
  def self.up
    change_column :accounts, :active, :boolean, :default => true
  end

  def self.down
    change_column :accounts, :active, :boolean, :default => nil
  end
end
