class AddFieldsToAccounts < ActiveRecord::Migration
  
  def self.up
      add_column  :accounts, :status, "enum('active', 'suspended', 'removed')"
      add_column  :accounts, :middle_initials, :string
      add_column  :accounts, :company_name, :string
      add_column  :accounts, :zip, :string
      add_column  :accounts, :address, :string
      add_column  :accounts, :address2, :string
      add_column  :accounts, :city_id,  :integer
      add_column  :accounts, :state_id, :integer
      add_column  :accounts, :country_id, :integer
      add_column  :accounts, :external_id, :integer
  end

  def self.down
    remove_column :accounts, :status
    remove_column :accounts, :middle_initials
    remove_column :accounts, :company_name
    remove_column :accounts, :zip
    remove_column :accounts, :address
    remove_column :accounts, :address2
    remove_column :accounts, :city_id
    remove_column :accounts, :state_id
    remove_column :accounts, :country_id
    remove_column :accounts, :external_id
  end
end
