class Admin::AdminController < ApplicationController
  before_filter :authenticate_admin_account
  # skip_before_filter :check_all_steps_verirification

  protected

  def authenticate_admin_account
    redirect_to root_path unless current_account && (current_account.admin? || current_account.manager?) 
  end
  
end