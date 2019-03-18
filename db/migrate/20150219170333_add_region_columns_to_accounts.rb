class AddRegionColumnsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :city_id, :string
    add_column :accounts, :state_id, :string
    add_column :accounts, :country_id, :string
  end
end
