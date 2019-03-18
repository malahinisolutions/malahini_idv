class Verifiers::OldverificationsController < ApplicationController
  before_action :authenticate_verifier!
  before_action :current_verifier_account
 def index
   @verifications = Account.joins("RIGHT OUTER JOIN  verifications ON verifications.account_id=accounts.id").select("accounts.aten_id,accounts.first_name,accounts.last_name,accounts.email,verifications.status,verifications.cancel_reason").order("verifications.created_at desc").page(params[:page]).per(20)
   render layout: "verifier_application"
 end
   
  def current_verifier_account
    current_verifier
  end
   
   
end
