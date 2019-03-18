class Authy::DeviseAuthyController < Devise::DeviseAuthyController
  skip_before_filter :check_all_steps_verirification
  # before_filter :check_for_a_temporary_user

  protected
  
  def after_authy_enabled_path_for(resource)
    verification_path
  end

  def after_authy_verified_path_for(resource)
    verification_path
  end

  def invalid_resource_path
    root_path
  end

  def check_for_a_temporary_user
    redirect_to :root if current_account && current_account.temporary
  end

end