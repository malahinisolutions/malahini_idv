class AddZipToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :zip, :string
  end
end
