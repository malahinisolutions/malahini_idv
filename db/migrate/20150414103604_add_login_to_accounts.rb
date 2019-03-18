class AddLoginToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :login, :string, after: :email
  end
end
