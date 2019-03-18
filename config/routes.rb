Rails.application.routes.draw do

  get  "images/:name" => "images#show", :as => :custom_image
  namespace :verifiers do
  # get 'verifiers/index'
  get "/verifications"=>"verifications#index"
  get "/verifications/:id"=>"verifications#edit", :as=> :user_verification
  post "/update"=>"verifications#update", :as=> :user_verification_update
  post "/decline"=>"verifications#decline", :as=>:decline
  get "/oldverifications"=>"oldverifications#index"
  end

  get "headshot_demo/index"
  post "headshot/capture" => "headshot#capture", :as => :headshot_capture
  get "locations/get_states"

  # get 'accounts/profile'

  # get 'accounts/change_password'

  # get 'accounts/wallet'
  devise_scope :account do
    get "/control/confirm_account_password", to: "registrations#confirm_account_password", as: :acc_password_confirmation
  end

  devise_for :verifiers, :controllers=>{sessions: "verifiers/sessions"}
  devise_for :accounts, :controllers => { sessions: "sessions", devise_authy: "authy/devise_authy", registrations: "registrations" }, :path_names => {
    :verify_authy => "/verify-token",
    :enable_authy => "/enable-two-factor",
    :verify_authy_installation => "/verify-installation"
  }

  # devise_for :verifiers, :controllers=> { sessions: "verifier/sessions"}

  root  "welcome#test"
  get  "/agreements" => "welcome#agreements"
  get  "/welcome" => "welcome#index"
  post "welcome/checkpassword"=>"welcome#checkpassword"

  # post "/agreements/check" => "welcome#check_agreements", as: :check_agreements


  # get "/control" => "welcome#index"
  get "/control/profile" => "accounts#profile"
  get "/control/change-password" => "accounts#change_password"
  get "/control/wallet" => "accounts#wallet"
  get "/control/download_wallet" => "accounts#download_wallet", as: :control_download_wallet

  get "/control/get_wallet" => "accounts#get_wallet", as: :get_wallet
  get "/control/get_wallet_version" => "accounts#get_wallet_version"

  post "/control/wallet" => "accounts#save_wallet", as: :wallet
  get "/control/confirm_aten_credentials" =>"accounts#confirm_aten_credentials", as: :aten_credentials_confirmation

  get "/control/security" => "accounts#security"
  get "/control/personal_information" => "accounts#form_for_personal_data", as: :personal_data
  post "/control/personal_information" => "accounts#save_personal_data", as: :save_personal_data


  post "/control/wallet" => "accounts#save_wallet", as: :wallets

  namespace :admin do
    resources :accounts, :wallets, :verifications, :cities, :countries, :states do
      as_routes
    end
    resources :account_permissions do
      as_routes
    end
  end



  namespace :api, :defaults => {:format => :json} do
    # post "/" => "main#call"
    post "/server-x" => "main#server_x_callback"
  end

  post "/locations/get_states" => "locations#get_states"
  post "/locations/get_cities" => "locations#get_cities"

  resources :locations, only: [] do
    get :search_city, :on => :collection
  end


  scope :verification do
    get "/financial" => "verifications#miicard_verification", as: :verification_financial
    get "/identify" => "verifications#identify", as: :verification_identify
    get "/iamreal" => "verifications#iamreal", as: :verification_iamreal
    # post "/iamreal" => "verifications#check_iamreal"
    get "/iamreal/callback" => "verifications#iamreal_callback"
    get "/" => "verifications#check_verifications", as: :verification
    get "/verify"=> "verifications#verify", as: :verify
    post "upload_image"=> "verifications#upload_image", as: :upload_image
    post "/identify/send" => "verifications#idchecker_verification", as: :verification_identify_send
    get "/authenticate_form" => "verifications#authenticate_form"
    post "identify/authenticid_callback" => "verifications#authenticid_callback"
    get "/thank_you" => "verifications#identify_thank_you", as: :verification_thank_you
  end


  resources :agreements, only: [] do
    collection do
      post :check_agreements, as: :check
      get :terms_of_use
      get :disclaimers
      get :privacy_police
      get :kyc_and_aml
    end
  end

end
