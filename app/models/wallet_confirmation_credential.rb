class WalletConfirmationCredential < ActiveRecord::Base
  include EncryptFactory
  extend ConfirmationHelper
    
  belongs_to :account
  
  def get_wallet_params
    { username: decrypt_data(login, ACCOUNT_CREDENTIALS_KEY), password: decrypt_data(password, ACCOUNT_CREDENTIALS_KEY) }
  end 
end
