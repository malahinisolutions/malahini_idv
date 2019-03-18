class CreateVerifications < ActiveRecord::Migration
  def change
    create_table :verifications do |t|
      t.integer :account_id
      t.column :verification_type, "enum('idchecker', 'directid')"
      t.column :status, "enum('pending', 'processed', 'cancelled')"
      t.string :cancel_reason, default: ""

      t.timestamps null: false
    end
  end
end
