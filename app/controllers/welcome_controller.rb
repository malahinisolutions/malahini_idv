class WelcomeController < ApplicationController
  # skip_before_filter :check_all_steps_verirification, only: [:index]
  before_filter :user_is_logged_in, only: [:test]

  def index
    if session[:current_user_ids]==USER_PASSWORD
      render layout: "index"
    else
      redirect_to action: "test"
    end
  end

  def agreements
    render layout: "auth"
  end

  def tutorial

  end

  def test
    if session[:current_user_ids]==USER_PASSWORD
      redirect_to :welcome
    else
      session[:current_user_ids] =''
      render :layout => false
      return
    end
  end

  def checkpassword
    if params[:userdata][:userpassword] ==USER_PASSWORD
      session[:current_user_ids] = USER_PASSWORD
      redirect_to :welcome
    else
      gflash :now, :error => "Password is incorrect"
      redirect_to action: "test"
    end
  end

  private

  def redirect_to_root
    redirect_to :verification if current_account
  end

  def user_is_logged_in
    redirect_to :welcome if current_account
  end

end
