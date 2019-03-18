class DeleteDeviseFromAccounts < ActiveRecord::Migration
  
  COLUMNS = [:reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count,
             :current_sign_in_at, :encrypted_password, :last_sign_in_ip, :last_sign_in_at,
             :current_sign_in_ip
            ] 
  
  def self.up
    COLUMNS.each do |column| 
      remove_column :accounts, column 
    end
  end

  def self.down
    add_column :accounts, :reset_password_token, :string
    add_column :accounts, :reset_password_sent_at, :datetime
    add_column :accounts, :remember_created_at, :datetime
    add_column :accounts, :sign_in_count, :integer
    add_column :accounts, :current_sign_in_at, :datetime
    add_column :accounts, :last_sign_in_at, :datetime
    add_column :accounts, :current_sign_in_ip, :string
    add_column :accounts, :last_sign_in_ip, :string
    add_column :accounts, :encrypted_password, :string
  end
end
