class UserVerification < ActiveRecord::Migration
  def change
    create_table :user_verifications do |t|
      t.integer :account_id
      t.column :status, "enum('pending', 'processed', 'cancelled')"
      t.string :document_path
      t.string :video_path
      t.string :comment, default: ""
      t.string :verified_by

      t.timestamps null: false
    end
  end
end

