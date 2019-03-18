class Verifiers::VerificationsController < ApplicationController
  before_action :authenticate_verifier!
  before_action :current_verifier_account
 def index
   #@verifications = UserVerification.order("created_at desc").page(params[:page]).per(20)
   if (params[:search] !='')
     @verifications = Account.select("accounts.id,accounts.email,accounts.aten_id,user_verifications.status,user_verifications.comment,user_verifications.first_name,user_verifications.last_name").joins("LEFT OUTER JOIN user_verifications ON accounts.id=user_verifications.account_id LEFT OUTER JOIN verifications  ON accounts.id=verifications.account_id").where("user_verifications.first_name LIKE ? OR user_verifications.last_name LIKE ? OR accounts.email LIKE ? OR user_verifications.status LIKE ? OR user_verifications.comment LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%","%#{params[:search]}%","%#{params[:search]}%","%#{params[:search]}%").order("user_verifications.created_at desc").page(params[:page]).per(20)
   else
     @verifications = Account.select("accounts.id,accounts.email,accounts.aten_id,user_verifications.status,user_verifications.comment,user_verifications.first_name,user_verifications.last_name").joins("LEFT OUTER JOIN user_verifications ON accounts.id=user_verifications.account_id LEFT OUTER JOIN verifications  ON accounts.id=verifications.account_id").order("user_verifications.created_at desc").page(params[:page]).per(20)
   end
   render layout: "verifier_application"
 end

 def self.search(search)
  where("first_name LIKE ? OR last_name LIKE ? ", "%#{search}%", "%#{search}%")
end

def edit
    #@verification = UserVerification.find(params[:id])
    @verification = Account.select("accounts.id,accounts.email,accounts.aten_id,user_verifications.status,user_verifications.comment,user_verifications.first_name,user_verifications.last_name,user_verifications.document_path,user_verifications.video_path,user_verifications.document_type,user_verifications.date_of_birth,user_verifications.country,user_verifications.city,user_verifications.zip,user_verifications.home_address,user_verifications.video_thumnail,user_verifications.pin,user_verifications.nationality,user_verifications.id as ids,user_verifications.created_at,user_verifications.updated_at,user_verifications.verified_by").joins("LEFT OUTER JOIN user_verifications ON accounts.id=user_verifications.account_id LEFT OUTER JOIN verifications  ON accounts.id=verifications.account_id").find(params[:id])
    @num=@verification[:pin].to_s
    render layout: "verifier_application"
  end
  def current_verifier_account
    current_verifier
  end
  def update
    verifier_comment=params[:comment]
    status=params[:status]
    if status =='accept'
      flash[:notice]="User has been verified to download wallet"
      verification_status='processed'
    else
      flash[:alert]="User has been declined to download wallet"
      verification_status='cancelled'
    end
    ver_id=params[:verification_id]
    ac_id=params[:account_id]
    current_verifier_email=params[:current_verifier_email]
    UserVerification.update(ver_id,:comment=>verifier_comment,:status=>verification_status,:verified_by=>current_verifier_email)
    verification= Verification.where(:account_id => ac_id,:status=>'pending').first
    verification.status=verification_status
    verification.cancel_reason=verifier_comment
    verification.save()

    redirect_to verifiers_verifications_path
  end
  def decline
    comment=params[:comment]
    #redirect_to verifiers_verifications_path
  end
end
