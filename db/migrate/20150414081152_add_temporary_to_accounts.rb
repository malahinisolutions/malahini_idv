class AddTemporaryToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :temporary, :boolean, default: true
  end
end
