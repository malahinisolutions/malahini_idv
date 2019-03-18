class AddIndexesToServerPubkeys < ActiveRecord::Migration
  def self.up
    add_index :server_pubkeys, :key
  end

  def self.down
    remove_index :server_pubkeys, :key
  end
end
