class ServerPubkey < ActiveRecord::Base
  has_many :api_accounts

  def to_label 
    "Server Pubkey #{id}"
  end
end
