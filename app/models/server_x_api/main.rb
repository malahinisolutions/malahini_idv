class ServerXApi::Main 

  SERVER_X_MIICARD_PATH = "api/check"
  SERVER_X_WALLET_DATA_PATH = "/api/save_wallet"
  SERVER_X_AUTHID_CALLBACK_PATH = '/callback/authenticid'

  ALGORITHM = "AES-256-CBC"
  SIGNATURE_TOKEN = SERVER_X_KEY
  PATH_TO_PHP_LIB = "lib/ext/php_lib/"
  ENCRYPT_PHP_FILE = "encrypt.php"
  DECRYPT_PHP_FILE = "decrypt.php"

  APPROVED_STATUS = "processed"
  DECLINED_STATUS = "cancelled"

  INCORRECT_SIGNATURE = "Incorrect signature for serverx callback "

  extend EncryptFactory
  # extend Sender
 
  def self.send_data( data ) # sending user data to serverX; response: token for widget
    data.select! { |_k, v| v.present? }

    encrypted_data = Base64.encode64(AESCrypt.encrypt_data(data.to_query, SERVER_X_KEY, SERVER_X_IV, ALGORITHM)).gsub("\n", "")

    final_string = { cmd: "get_token", data: encrypted_data.gsub("\n", ""), sign: create_sign( data, SERVER_X_KEY )  }

    response = CustomSender.new( SERVER_X_URL + SERVER_X_MIICARD_PATH ).post_data( final_string )

    begin
      JSON.parse( response )
    rescue JSON::ParserError => e
      {result: "error"}
    end
  end

  def self.process_callback( params ) # callback after verification from ServerX
    # params = { data: "uY7M8zbFGU2vRcBDmlCUwikdz+ocTWdUAVIkyGZDZzk=", sign: "7b4b215544f4338aff35cf8d0024fd52" }

    decrypted_data = AESCrypt.decrypt_data(Base64.decode64(params["data"]), SERVER_X_KEY, SERVER_X_IV, ALGORITHM)
    data = JSON.parse( decrypted_data )

    return INCORRECT_SIGNATURE if params["sign"] != Digest::MD5.hexdigest( Hash[data.sort_by{ |k, v| k.to_i }].to_json + SIGNATURE_TOKEN)

    data.map do | user_id, user_credentials |
      acc = Account.find(user_id)
      opts = { verification_type: user_credentials["type"], status: user_credentials["status"], cancel_reason: user_credentials["cancel_reason"]  }
            
      verification = Verification.where(verification_type: user_credentials["type"], account: acc, status: "pending").last
      
      if verification
        verification.update_attributes(opts)
        acc.verify( verification )
      else
        new_verification = Verification.new(opts)
        new_verification.account_id = user_id
        new_verification.save!
        acc.verify( new_verification )
      end

      send_notification(acc.email, acc.login, user_credentials["status"], user_credentials["cancel_reason"]) 
    end

    return "ok"
  end

  def self.send_wallet_credentials(data)   
    encrypted_data = Base64.encode64(AESCrypt.encrypt_data(data.to_query, SERVER_X_KEY, SERVER_X_IV, ALGORITHM)).gsub("\n", "")
    params = { cmd: "save_wallet_credentials", data: encrypted_data.gsub("\n", ""), sign: create_sign( data, SERVER_X_KEY )  }

    CustomSender.new( SERVER_X_URL + SERVER_X_WALLET_DATA_PATH ).post_data( params )
  end

  def self.send_notification( email, first_name, status, reason )
    if status == APPROVED_STATUS
      AccountMailer.verification_success(email, first_name).deliver_now
    else
      AccountMailer.verification_failed(email, first_name, reason).deliver_now
    end
  end

  private

  def self.create_sign( data, key ) 
    Digest::MD5.hexdigest( data.keys.sort.map { |key| data[key].to_s }.inject(:+) + key )
  end

end
