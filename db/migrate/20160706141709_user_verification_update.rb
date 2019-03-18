class UserVerificationUpdate<  ActiveRecord::Migration
  def change
    add_column :user_verifications, :document_type, :string
    add_column :user_verifications, :first_name, :string
    add_column :user_verifications, :last_name, :string
    add_column :user_verifications, :date_of_birth, :date
    add_column :user_verifications, :nationality, :string
    add_column :user_verifications, :country, :string
    add_column :user_verifications, :city, :string
    add_column :user_verifications, :zip, :string
    add_column :user_verifications, :home_address, :string
  end
end