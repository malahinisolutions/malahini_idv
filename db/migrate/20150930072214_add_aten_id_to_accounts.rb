class AddAtenIdToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :aten_id, :string
  end
end
