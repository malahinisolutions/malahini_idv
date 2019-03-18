class AccountsController < ApplicationController
  DATA_STRING_PATTERN = "%s.%s.%s"
  ARCHIVE_NAME_PATTERN = "wallets%s"

  #POSSIBLE_ARCHIVES = ["windows/atenblackgoldcoin-qt.zip", "windows/atenblackgoldcoin-qt.exe",
  #                     "macos/AtenBlackGoldCoin-Qt.zip"
  #                    ]

  POSSIBLE_ARCHIVES = ["windows/Atencoin-qt.zip", "windows/Atencoin-qt.exe",
                       "macos/Atencoin-Qt.zip"
                      ]

   before_action :authenticate_account!, except: [:get_wallet, :get_wallet_version]

   before_filter :check_all_steps_verirification, except: [:get_wallet, :security, :form_for_personal_data, :save_personal_data]


  before_action :set_current_account, only: [:profile, :wallet, :save_wallet]
  before_action :set_wallet_for_account, only: [:wallet, :save_wallet]
  # before_action :check_all_verifications_steps, only: [:wallet, :update_wallet]

  def profile
  end

  def download_wallet # GET
  end

  def get_wallet # GET
    download_file = params[:file_name]

    case download_file
    when 'windows/atenblackgoldcoin-qt.zip'
      download_file = 'windows/Atencoin-qt.zip'
    when 'windows/atenblackgoldcoin-qt.exe'
      download_file = 'windows/Atencoin-qt.exe'
    when 'macos/AtenBlackGoldCoin-Qt.zip'
      download_file = 'macos/Atencoin-Qt.zip'
    end
    redirect_to root_path and return if !POSSIBLE_ARCHIVES.include?(download_file)
    send_file(ARCHIVE_NAME_PATTERN % ("/" + download_file), x_sendfile: true)
  end

  def change_password
  end

  def get_wallet_version
    render json: { version: CURRENT_WALLET_VERSION }
  end

  def wallet # GET /control/wallet
  end

  def security # GET /control/security
  end

  def form_for_personal_data # GET /control/personal_information
    verifications = Verification.where(account: current_account, verification_type: "iamreal")
    if !(!verifications.any? || verifications.last.status == "cancelled")
      redirect_to verification_path
    end
  else
    @country = params[:country_id] ? [Country.find_by_Code(params[:country_id]).name, params[:country_id]] : ["", ""]
  end

  def save_personal_data # POST /control/personal_information
    personal_data = AccountPersonalInformation.new( personal_data_params )
    dob = DATA_STRING_PATTERN % [params["date_of_birth(3i)"], params["date_of_birth(2i)"], params["date_of_birth(1i)"]]
    personal_data.date_of_birth = dob

    if personal_data.valid?
      session[:current_account_information] = {             id: current_account.id.to_s,
                                                       aten_id: current_account.aten_id,
                                                    first_name: params[:first_name],
                                                     last_name: params[:last_name],
                                                           dob: dob,
                                               middle_initials: params[:middle_initials].to_s,
                                                   nationality: params[:nationality],
                                                       country: params[:country_id],
                                                          city: params[:city_id],
                                                         state: (params[:state_id] ? State.find(params[:state_id]).name : ""),
                                                  home_address: params[:home_address],
                                                           zip: params[:zip],
                                               mailing_address: params[:mailing_address]
                                              }
      #redirect_to session[:url_from]
      redirect_to '/verification/verify'
    else
      @default_time = !params["date_of_birth(1i)"].blank? && !params["date_of_birth(2i)"].blank? && !params["date_of_birth(2i)"].blank? ? Time.parse(dob) : nil
      @country = params[:country_id] ? [Country.find_by_Code(params[:country_id]).name, params[:country_id]] : ["", ""]
      @errors = personal_data.errors.full_messages
      render :form_for_personal_data
    end
  end

  def save_wallet # POST /wallet
    # updated_wallet = Wallet.update_wallet( @wallet, wallet_params )

    wallet = Wallet.new(wallet_params)
    wallet.account = @wallet.account

    if wallet.valid?
      wallet.encrypt_credentials.save_and_send_mail
      redirect_to( :root, notice: t("accounts.send_wallet_credentials") )
    else
      gflash :now, error: wallet.errors.full_messages.first
      set_wallet_params
      set_wallet_for_account
      render :wallet
    end
  end

  def confirm_aten_credentials
    token = params[:confirmation_token]
    aten_credentials = WalletConfirmationCredential.find_by_token(token)

    if aten_credentials.nil?
      gflash :now, error: "Invalid confirmation token."
    else

      # begin
        Wallet.update_wallet(aten_credentials.account, aten_credentials.get_wallet_params)
      # rescue StandardError => e
        # gflash :now, error: e.message
      # else
        aten_credentials.destroy
        gflash success: "Aten credentials were updated successfully."
      # end

    end

    redirect_to root_path
  end

  private

  def personal_data_params
    params.permit(:first_name, :last_name, :middle_initials,
                  :nationality, :country_id, :city_id, :state_id, :zip, :home_address, :mailing_address
                 )
  end

  def wallet_params
    params.require(:wallet).permit( :username, :password )
  end

  def set_wallet_params
    begin
      @username, @password = params[:wallet][:username], params[:wallet][:password]
    rescue NoMethodError => e
      @username, @password = "", ""
    end
  end

  def set_wallet_for_account
    @wallet = current_account.wallet ? current_account.wallet : Wallet.new(account: current_account)
  end

  def set_current_account
    @account = current_account
  end

end
