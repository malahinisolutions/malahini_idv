class Wallet < ActiveRecord::Base

  include EncryptFactory

  belongs_to :account
  
  validates_presence_of :username, :password
  validates_length_of   :username, :password, in: 7..32

  validate :uniq_username
  validate :username_not_eq_password


  def to_label
    account ? "Walet for #{account.email}" : "Wallet #{id}"
  end
  

  def self.get_accounts(time_to, time_from)
    includes(:account).where(updated_at: time_to..time_from  ).all.map do | wallet |
      { login: wallet.username, password: wallet.password }.merge(wallet.account.to_hash)
    end
  end

  def self.update_wallet(wallet_account, wallet_params)
    wallet = wallet_account.wallet
    wallet ||=  Wallet.new(account: wallet_account)
    
    wallet.username = wallet.hexdigest_string(wallet_params[:username])
    wallet.save(validate: false)
      
    sever_x_params = { id: wallet.account_id.to_s, username: wallet_params[:username], password: wallet_params[:password] }
                       
    aten_gateway_params = wallet.account.to_hash( wallet_params[:username], wallet_params[:password] )

    ServerXApi::Main.send_wallet_credentials( sever_x_params ) # sending credentials to serverX
    AtenGatewayApi::Main.send_wallet_credentials( aten_gateway_params ) # sending credentials to AtenBlackGoldCoinGateway
  end


  def hexdigest_string(string)
    Digest::MD5.hexdigest(string)
  end

  def save_and_send_mail
    token = account.generate_pasword_confirmation_token

    temp_save_credentials(token)
    send_confirmation_mail(token)
  end 


  def encrypt_credentials    
    self.username = encrypt_data(username, ACCOUNT_CREDENTIALS_KEY)
    self.password = encrypt_data(password, ACCOUNT_CREDENTIALS_KEY)
    self
  end

  protected

  def temp_save_credentials(token)
    WalletConfirmationCredential.new do |cred|
      cred.account = account
      cred.password = password
      cred.login = username
      cred.token = token
      cred.save!
    end
  end

  def send_confirmation_mail(token)
    AccountMailer.confirm_wallet_credentials(account.email, token).deliver_now
  end

  def username_not_eq_password
    self.errors.add(:base, "Username does not have to match the password") if username == password
  end

  def uniq_username
    usernames = Wallet.where(username: hexdigest_string(username))
    self.errors.add(:base, "Username already exist") if usernames.any?
  end

end
