class Api::Main 
  include ApiHelper

  PRIVATE_KEY = "8089bc9304adfa7fa6655990b995dfffc2ad1f0b0c7be147f622b5f32dd22eab"
  PATH_TO_FILE = "./src/signaten"
  
  POSSIBLE_CMDS = ["register_address", "get_current_server_pubkey", "sign_output", "sign_transaction"]
  PARAMS_FOR_CMDS = {
    "register_address" => [:cmd, :login, :hash, :client_pubkey, :server_pubkey],
    "get_current_server_pubkey" => [:cmd], 
    "sign_output"      => [:cmd, :login, :hash, :server_pubkey, :output_hash],
    "sign_transaction" => [:cmd, :login, :hash, :transaction_hash]
  }

  def initialize(params, request)
    @params = params
    @request = request

    @response = Hash.new

    @custom_params = PARAMS_FOR_CMDS.each {|k,v| break v if @params[:cmd] == k}

    # @connection = AtencoinRPC.new(atencoin_url)
  end

  def call
    validation = Api::Validation.new(@params, @request)
    
    @response = validation.request_errors.blank? ? send(@params[:cmd].to_s) : validation.request_errors
    
    # @response =   
      # if validation.request_errors.blank?
      #   send(@params[:cmd].to_s)      
      # else
      #   validation.request_errors
      # end
  end


  private

  #{:cmd=>"register_address", :login=>"1", :hash=>"***", :client_pubkey=>"dasdsa", :server_pubkey=>"234e5rdetcgyrher8324hyfrbvwhwefjbvjrkvnrl34"}
  def register_address
    
    client_pubkey = @params[:client_pubkey]
    server_pubkey = ServerPubkey.find_by_key(@params[:server_pubkey])
    
    if !server_pubkey || Time.now > server_pubkey.expiration_date
      return @response = { result: "error", comment: "not valid server pubkey" } 
    end

    api_account = ApiAccount.new
    api_account.account_id = Account.where(login: @params[:login]).take.id
    api_account.client_pubkey = client_pubkey
    api_account.server_pubkey_id = server_pubkey.id
    api_account.save!

    @response = 
      if api_account.persisted?
        { result: "success", comment: "address registered" }
      else
        { result:   "error", comment: "address has not been registered" }
      end

  end


  # {cmd: "get_current_server_pubkey"}
  def get_current_server_pubkey

    server_pubkey =  ServerPubkey.last 

    @response = { result: "success", server_pubkey: server_pubkey.key, 
                  expiration_date: server_pubkey.expiration_date.to_i.to_s }
  end

  
  # {cmd: "sign_output", login: "1", hash: "***", server_pubkey: "046a5bc8a25cdc4b461d0d7a2b19c182db7e9a7aec05a736b8eb793027bc6ce05b9b1495dc305ec519cb3c693fd0a2b5466563b46be91d06c5f3cbb0ac0b804e38",  output_hash: "dasd"}
  def sign_output
    output_hash = @params[:output_hash]

    # private key to sign the hash of the public key

    @response = call_cpp_file(output_hash)
  end

  
  # {cmd: "sign_transaction", login: "1", hash: "***", transaction_hash: "fhdbgklfn"}
  def sign_transaction
    transaction_hash = @params[:transaction_hash]
    
    @response = call_cpp_file(transaction_hash)
  end

  def call_cpp_file(param)
    output = `#{PATH_TO_FILE} #{param} #{PRIVATE_KEY}`
    response = JSON.parse output
    status = response["result"] == true ? "success" : "error"

    {result: status, signature: response["signature"]}
  end



end