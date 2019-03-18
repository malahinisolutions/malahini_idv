class CreateServerPubkeys < ActiveRecord::Migration
  def change
    create_table :server_pubkeys do |t|
      t.string   :key
      t.datetime :expiration_date

      t.datetime :created_at
    end
  end
end
