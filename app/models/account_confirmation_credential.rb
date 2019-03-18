class AccountConfirmationCredential < ActiveRecord::Base

  include EncryptFactory
  extend ConfirmationHelper

  belongs_to :account

  def get_account_params
    { password:  decrypt_data(password, ACCOUNT_CREDENTIALS_KEY) }
  end 
end
