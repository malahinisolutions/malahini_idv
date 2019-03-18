require 'net/http'
require 'uri'

class CustomSender
  
  attr_reader :uri

  def initialize( url )
    @uri = URI.parse(url) 
  end

  def post_data( data )
    req = Net::HTTP::Post.new(@uri, initheader = {'Content-Type' =>'application/json'})
    req.set_form_data( data )

    http = Net::HTTP.new(@uri.host, @uri.port)

    if https?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    

    resp = http.start {|http| http.request(req) }
    resp.body

  end

  def get_data
    response = Net::HTTP.start(@uri.host, @uri.port, use_ssl: https?) do |http|
      request = Net::HTTP::Get.new(@uri)
      http.request(request) 
    end

    response.body
  end

  private

  def https?
    @uri.scheme == "https"
  end

end