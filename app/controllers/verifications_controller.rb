require 'uri'
require 'net/http'

class VerificationsController < ApplicationController
  before_action :authenticate_account!

  helper :headshot

  SUCCESS_RESPONSE_STATUS = "success"
  # CREATE_DOSSIER_PATH = "api/v2/StrongID"
  # SEND_DOSSIER_PATH = "api/v2/StrongID?dossierId=%s"
  ID_CHECKER_PATH = "api/initiate_merchant_session"
  IAMREAL_PATH = "api/iamreal"
  SYSTEM_TYPE = "authenticid"
  PENDING_STATUS = "pending"

  DIRECTID_MODES = {  live:
                     { css_url: "https://az720787.vo.msecnd.net/content/latest-release/directid.min.css",
                        js_url: "https://az720787.vo.msecnd.net/content/latest-release/directid.min.js" },
                      demo:
                     { css_url: "https://az720787.vo.msecnd.net/content/latest-release/directid.min.css",
                        js_url: "https://az720787.vo.msecnd.net/content/latest-release/directid.min.js" },
                   }

  # ID_CHECKER_URL = "https://demo.idchecker.com/IDchecker.WebAPI.StrongID/Api/v2/StrongID/"
  # ID_CHECKER_URL = "https://accplatform.idchecker.nl/idchecker.webapi.strongid/api/v2/strongid/"

  skip_before_filter :verify_authenticity_token

  before_action :set_user, only: [:miicard_verification, :check_verifications]
  before_action :create_personal_data, only: [:miicard_verification, :identify, :iamreal]


  def miicard_verification
    # opts = { id: @account.id.to_s, first_name: @account.login, last_name: @account.email }
    response = ServerXApi::Main.send_data( session[:current_account_information].symbolize_keys )

    if response["result"] == SUCCESS_RESPONSE_STATUS
      session[:current_account_information] = nil
      @token = response["data"]["token"]
      #@urls = DIRECTID_MODES[DIRECTID_MODE.to_sym
      #render partial: "miicard", locals: { token: @token, urls: DIRECTID_MODES[DIRECTID_MODE.to_sym] }
      render "miicard_verification", locals: { token: @token, urls: DIRECTID_MODES[DIRECTID_MODE.to_sym] }
    else
      redirect_to :verification, alert: "Service is temporarily unavailable."
    end
  end

  def idchecker_verification
    # raise params[:account].inspect
    # params_with_country = params[:account].merge({country: session[:current_account_information]["country"]})

    # instance = IdChecker::Main.new(params[:account])

    # if !instance.valid?

    #   @only_document_form = instance.skip_photos?

    #   @photos = @only_document_form ? [instance.live_photo_1, instance.live_photo_2] : ["", ""]
    #   @countries = Country.with_backside_document.pluck(:code)

    #   gflash :now, :error => "Error!"#instance.errors.full_messages.first
    #   render :identify
    # else
    #   photos = instance.photos_to_json

    #   response = IdChecker::Main.send_data( session[:current_account_information], photos )

    #   if response["result"] == "success"
    #     Verification.create(account: current_account, verification_type: SYSTEM_TYPE, status: PENDING_STATUS)
    #     session[:current_account_information] = nil
    #     @data = response["data"]
    #     render :authenticate_form
    #   else
    #     gflash :now, :error => "Service is temporarily unavailable."
    #     set_user
    #     render :check_verifications
    #   end
    # end
  end

  def identify
    # @countries = Country.with_backside_document.pluck(:code) # countries with backside document scans
    # @photos = ["", ""]
    # @url = verification_identify_send_path
    url = SERVER_X_URL + ID_CHECKER_PATH
    response = IdChecker::Main.send_data( session[:current_account_information], url, "authenticid", nil )

    if response["result"] == "success"
      Verification.create(account: current_account, verification_type: SYSTEM_TYPE, status: PENDING_STATUS)
      session[:current_account_information] = nil
      @data = response["data"]
      render :authenticate_form
    else
      gflash :now, :error => "Service is temporarily unavailable."
      set_user
      render :check_verifications
    end
  end

  def iamreal
    url = SERVER_X_URL + IAMREAL_PATH
    response = IdChecker::Main.send_data( session[:current_account_information].merge({"email" => current_account.email }), url, "iamreal", nil )
    # IamrealAccountId.create
    # raise response.inspect
    begin
      guid = JSON.parse(response["data"])["guid"]
    rescue StandardError => e
      gflash :now, :error => "Service is temporarily unavailable."
      redirect_to :verification and return
    else
      IamrealAccountId.create(iamreal_id: guid, account_id: current_account.id)
      render partial: "verifications/iamreal_layout", locals: { url: IAMREAL_LIB_URL, guid: guid, redirect_url: iamreal_callback_url }
    end
  end

  # def check_iamreal
  #   Verification.create(account: current_account, verification_type: "iamreal", status: PENDING_STATUS)
  #   render json: { status: "verifcation created" }
  # end

  def iamreal_callback
    iamreal = IamrealAccountId.find_by_iamreal_id(params["iar-guid"])
    if params["iar-msg"] == "Done" && iamreal
      Verification.create(account_id: iamreal.account_id, verification_type: "iamreal", status: PENDING_STATUS)
      session[:current_account_information] = nil
      gflash :success => "Data was successfully sent. Confirmation expected."
    else
      gflash :now, :error => "Service is temporarily unavailable."
    end

    redirect_to :verification
    # render text: params
  end

  def check_verifications
    if current_account.verified?
      redirect_to control_profile_path
    end
  end

  def verify
    verifications = Verification.where(account: current_account, verification_type: "iamreal")
    if (!verifications.any? || verifications.last.status == "cancelled") && session[:current_account_information]
      @user=HashWithIndifferentAccess.new(session[:current_account_information].merge({"email" => current_account.email }))
      @number=RandomNumber.new.getNumber
      session[:pin]=@number
      render :layout => false
      return
    end
    else
      redirect_to action: 'check_verifications'
  end
  def upload_image
    filename= DataFile.save_file(params[:upload])
    videoPath='https://eu1-addpipe.s3.eu-central-1.amazonaws.com/2220b2ce9a8c14ae206faef9d8e67c98/'+ params[:video_id]+'.mp4'
    videoThumb='https://eu1-addpipe.s3.eu-central-1.amazonaws.com/2220b2ce9a8c14ae206faef9d8e67c98/'+ params[:video_id]+'.jpg'
    doctype=params[:document_type]
    verifications = Verification.where(account: current_account, verification_type: "iamreal")
    if (!verifications.any? || verifications.last.status == "cancelled")
      Verification.where(account: current_account, verification_type: "iamreal", status: "cancelled").delete_all
      UserVerification.where(account_id: current_account,status: "cancelled").delete_all
    end
    Verification.create(account_id:current_account.id , verification_type: "iamreal", status: PENDING_STATUS)
    user=HashWithIndifferentAccess.new(session[:current_account_information])
    #UserVerification.create(account_id:user[:id],status:PENDING_STATUS,document_path:filename,video_path:videoPath,video_thumnail:videoThumb,document_type:doctype,first_name:user[:first_name],last_name:user[:last_name],date_of_birth:user[:dob],nationality:user[:nationality],country:user[:country],city:user[:city],home_address:user[:home_address],zip:user[:zip],email:current_account.email,pin:session[:pin])
    UserVerification.create(account_id:user[:id],status:PENDING_STATUS,document_path:filename,video_path:videoPath,video_thumnail:videoThumb,document_type:doctype,first_name:user[:first_name],last_name:user[:last_name],date_of_birth:user[:dob],nationality:user[:nationality],country:user[:country],city:user[:city],home_address:user[:home_address],zip:user[:zip],email:current_account.email,pin:session[:pin])
    session[:current_account_information]=nil
    redirect_to action: 'check_verifications'
  end
  def idchecker_callback_classification_result
    render text: params.inspect
  end

  def authenticate_form
  end

  def identify_thank_you # authentic_id GET
  end

  def authenticid_callback # POST
    opts = params
    BackgroundSenderJob.perform_later(opts)

    redirect_to :verification_thank_you
  end

  private

  # def skip_photos?(account_params)
  #   account_params && (account_params[:account_document_1].nil?) && (!account_params[:live_photo_1].blank? && !account_params[:live_photo_2].blank?) ? true : false
  # end

  def create_personal_data
    session[:url_from] = request.fullpath#request.env["REQUEST_URI"]
    redirect_to :control_personal_information unless session[:current_account_information]
  end

  # def process_live_photo(file_name)
  #   if file_name
  #     path = Rails.root.join("headshots", file_name)
  #     encoded_str = Base64.encode64(File.open(path, "rb") {|file| file.read}).gsub("\n", "")
  #   else
  #     nil
  #   end
  # end

  # def data_image(image)
  #   Base64.encode64(File.read(image.tempfile)).gsub("\n", '')
  # end

  def set_user
    @account = current_account
  end
end
