class AccountMailer < ApplicationMailer
  FAILED_SUBJECT  = 'Verification failed'
  SUCCESS_SUBJECT = 'Verification success'
  CONFIRM_ACC_PASS = "Confirm new login password"
  CONFIRM_WALLET_CRED = "Confirm new Aten credentials"

  default from: EMAIL_FROM

  def verification_failed( email, first_name, reason)
    attach_logo
    @first_name = first_name
    @reason = reason.to_s.downcase.capitalize.gsub("_", " ")
    mail(to: email, subject: FAILED_SUBJECT)
  end

  def verification_success(email, first_name)
    attach_logo
    @first_name = first_name
    mail(to: email, subject: SUCCESS_SUBJECT)
  end

  def confirm_new_account_password(email, first_name, token)
    attach_logo
    @email = email
    @token = token
    mail(to: @email, subject: CONFIRM_ACC_PASS)
  end

  def confirm_wallet_credentials(email, token)
    attach_logo
    @email = email
    @token = token
    mail(to: @email, subject: CONFIRM_WALLET_CRED)
  end

end