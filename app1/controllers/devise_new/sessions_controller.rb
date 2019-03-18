class DeviseNew::SessionsController < Devise::SessionsController 
  # skip_before_filter :require_no_authentication, :only => [:new]  


  def create
    if verify_recaptcha
      super
    else
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "There was an error with the recaptcha code below. Please re-enter the code."      
      flash.delete :recaptcha_error
      render :new
    end
  end    

end