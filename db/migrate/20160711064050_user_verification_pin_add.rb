class UserVerificationPinAdd<  ActiveRecord::Migration
  def  change
    add_column :user_verifications, :pin, :integer
    add_column :user_verifications, :email, :string

  end
end