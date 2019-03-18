class AddAccountIdToHeadshotPhotos < ActiveRecord::Migration
  def change
    add_column :headshot_photos, :account_id, :integer
    add_index :headshot_photos, :account_id
  end
end
