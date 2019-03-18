class Api::MainController < ApplicationController
  
  skip_before_filter :verify_authenticity_token  

  # def call
  #   @response = Api::Main.new( params, request ).create_response
  #   respond_to do |format|
  #     format.json { render json: @response}
  #   end
  # end

  def server_x_callback
    response = ServerXApi::Main.process_callback( params )
    render text: response
  end

  # def write_params_in_file
  #   fname = "test.txt"
  #   file = File.open(fname, "w")
  #   file.puts "#{params}\n"
  #   file.close
  # end

end
