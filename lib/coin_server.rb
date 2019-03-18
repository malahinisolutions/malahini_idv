require 'net/http'
require 'addressable/uri'
require 'json'

class CoinServer
	def initialize(coin_name)
		
		config_file = File.open(File.join(Rails.root, "config", "#{coin_name}.yml"))
    config = YAML::load(config_file)[Rails.env].symbolize_keys

    @address  = Addressable::URI.parse config[:url]
    @username = config[:username]
    @password = config[:password]

	end

  def is_valid_address?(address)
  	(address == address.strip) and request(method: "validateaddress", params: [address])['isvalid']
  end

  def is_my_address?(address)
    request(method: "validateaddress", params: [address])['ismine']
  end

  def get_account(address)
    request(method: "getaccount", params: [address])
  end

  def generate_new_address(account_id)
    request(method: "getnewaddress", params: [account_id.to_s])
  end

  def get_list_transactions(account_id)
    request(method: "listtransactions", params: [account_id.to_s])
  end

  def send_coins(address, amount)
    request(method: "sendtoaddress", params: [address, amount])
  end

  def get_balance
    request(method: "getbalance")
  end

	private

	def request(params)
    
    result = nil

    full_params = params.merge({
        :jsonrpc => "2.0",
        :id => (rand * 10 ** 12).to_i.to_s
      })

    request_body = full_params.to_json

    Net::HTTP.start(@address.host, @address.port) do |connection|
      post = Net::HTTP::Post.new(@address.path)
      post.body = request_body
      post.basic_auth(@username, @password)
      result = connection.request(post)
      result = JSON.parse(result.body)
    end

    if error = result["error"]
      raise "#{error["message"]}, request was #{request_body}"
    end

    result = result["result"]
    result
  end

end
