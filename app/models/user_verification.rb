 class UserVerification < ActiveRecord::Base
  belongs_to :account
  scope :processed,   ->{ where( status: "processed" ) }
end