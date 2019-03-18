class AddPeselNumberToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :pesel_number, :string
  end
end
