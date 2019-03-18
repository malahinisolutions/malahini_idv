class Api::MainController < ApplicationController


  #POST-request  
  def call 
    @api_response = Api::Main.new(params, request).call
    respond_to do |format|
      format.json { render json: @api_response}
    end
  end

  def index
  end

end
