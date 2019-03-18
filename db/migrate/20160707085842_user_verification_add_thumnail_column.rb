class UserVerificationAddThumnailColumn<  ActiveRecord::Migration
  def  change
    add_column :user_verifications, :video_thumnail, :string
  end
end
