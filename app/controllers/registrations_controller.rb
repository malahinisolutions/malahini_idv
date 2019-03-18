class RegistrationsController < Devise::RegistrationsController
  before_filter :check_all_steps_verirification, only: [:update, :edit]
  include EncryptFactory
  layout "auth", except: [:update]

  def create
    build_resource(sign_up_params)

    resource.save

    yield resource if block_given?
    if resource.persisted?
      resource.set_aten_id
      resource.save!

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    super
  end

  def update
    # super
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)


    if valid_resource?(resource, account_update_params)

      token = resource.generate_pasword_confirmation_token
      save_credentials(resource, token, encrypt_data(account_update_params[:password], ACCOUNT_CREDENTIALS_KEY))
      send_confirmation_mail(resource, token)

      yield resource if block_given?

      if is_flashing_format?
        set_flash_message :notice, :send_confirmation_password_mail
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def confirm_account_password
    token = params[:confirmation_token]
    acc_credentials = AccountConfirmationCredential.find_by_token(token)

    if acc_credentials.nil?
      set_flash_message :alert, :confirm_token_error
      redirect_to root_path
    else
      acc_credentials.account.update_attributes!(acc_credentials.get_account_params)
      acc_credentials.destroy
      set_flash_message :notice, :confirm_token_success
      redirect_to new_account_session_path
    end
  end

  protected

  def save_credentials(resource, token, password)
    AccountConfirmationCredential.new do |cred|
      cred.account_id = resource.id
      cred.token = token
      cred.password = password
      cred.save!
    end
  end

  def send_confirmation_mail(resource, token)
    AccountMailer.confirm_new_account_password(resource.email, resource.first_name, token).deliver_now
  end

  def valid_resource?(resource, params)
    # password.present? && password_confirmation.present? && password == password_confirmation && valid_password?(current_password)
    # raise params.inspect
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if resource.valid_password?(current_password)
      true
    else
      resource.assign_attributes(params)
      resource.valid?
      resource.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords(resource)
    result
  end

end
