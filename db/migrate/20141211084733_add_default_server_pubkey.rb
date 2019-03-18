class AddDefaultServerPubkey < ActiveRecord::Migration
  KEY = "046a5bc8a25cdc4b461d0d7a2b19c182db7e9a7aec05a736b8eb793027bc6ce05b9b1495dc305ec519cb3c693fd0a2b5466563b46be91d06c5f3cbb0ac0b804e38" 

  def self.up
    ServerPubkey.create(key: KEY, expiration_date: Time.now + 1.year)
  end

  def self.down
    ServerPubkey.find_by_key(KEY).destroy
  end
end
