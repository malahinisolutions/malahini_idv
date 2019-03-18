class UserVerificationPinUpdate <ActiveRecord::Migration
  def  change
    change_column :user_verifications, :pin, :string
  end
end