class ApiAccount < ActiveRecord::Base
  belongs_to :account
  belongs_to :server_pubkey
end
