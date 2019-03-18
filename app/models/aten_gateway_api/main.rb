class AtenGatewayApi::Main

  def self.send_wallet_credentials(data)
    if API_EXTERNAL_URL
      encrypted_data = encrypt( data.to_s )
      CustomSender.new( API_EXTERNAL_URL ).post_data( 
        {cmd: "create_account", data: encrypted_data, signature:  make_signature(data, API_EXTERNAL_SECRET_KEY)  } 
      )
    else
      raise "Service is temporarily unavailable."
    end
  end

  protected

  def self.decrypt( data )
    cipher = Gibberish::AES.new( API_EXTERNAL_SECRET_KEY )
    cipher.dec(data)
  end

  def self.encrypt( data )
    cipher = Gibberish::AES.new( API_EXTERNAL_SECRET_KEY )
    cipher.enc( data )
  end

  def self.make_signature(data, token)
    Digest::MD5.hexdigest( data.values.map(&:to_s).sort.inject(:+) + token )
  end

  def bgcw_get_updated_accounts( params )
    time_to = Time.at( params[:time_to].to_i )
    time_from = Time.at( params[:time_from].to_i )
    Wallet.get_accounts(time_from, time_to)
  end

end
