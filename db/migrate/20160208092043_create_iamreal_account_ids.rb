class CreateIamrealAccountIds < ActiveRecord::Migration
  def change
    create_table :iamreal_account_ids do |t|
      t.string :iamreal_id, index: true
      t.integer :account_id

      t.datetime :created_at
    end
  end
end
