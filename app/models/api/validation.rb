class Api::Validation < Api::Main



  VALIDATIONS = ["validate_cmd", "validate_of_presence_params", "validate_server_key", "validate_auth_params"]

  def initialize(params, request)
    super
    @error = {}
  end

  def request_errors
    # write_params_in_file

    VALIDATIONS.each do |validation|
      send(validation)
      break @error if @error.any?
    end

    @error
  end


  def validate_cmd
    unless POSSIBLE_CMDS.include? @params[:cmd].to_s
      @error =  get_error("Incorrect cmd.", "101")
    end
  end


  def validate_of_presence_params
    @custom_params.each do |p|
      break @error =  get_error("#{p.to_s.capitalize} parameter is missing.", "102") if !@params.include? p
    end
  end

  def validate_auth_params
    return nil if @params[:cmd] == "get_current_server_pubkey"

    unless Account.all.map(&:login).include? @params[:login]
      @error = get_error("Incorrect login.", "101")
    end

    login = @params[:login]

    params_for_hash = @params.except(:hash, :action, :format, :controller)
    
    password = Account.find_by_login(login).password
    
    hash = Digest::MD5.hexdigest(params_for_hash.values.map(&:to_s).sort.inject(:+) + password)
    
    return @error = get_error("Incorrect hash for authentication.", "107") if @params[:hash] != hash
    
    #....
  end

  def validate_server_key
    if @params[:server_pubkey]
      server_pubkey =  ServerPubkey.find_by_key(@params[:server_pubkey])
      if !server_pubkey || Time.now > server_pubkey.expiration_date
        @error = get_error("Not valid server pubkey", "101") 
      end
    end
  end
    

  def get_error(comment, status)
    {result: "error", comment: comment, status: status}
  end

  def write_params_in_file
    fname = "test.txt"
    file = File.open(fname, "w")
    file.puts "#{@params}\n"
    file.close
  end



end 