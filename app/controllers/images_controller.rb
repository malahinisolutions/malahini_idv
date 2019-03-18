class ImagesController< ApplicationController
  def show
    p=params
    send_file File.join(params[:name]+"."+params[:format]), :disposition => 'inline'
  end
end