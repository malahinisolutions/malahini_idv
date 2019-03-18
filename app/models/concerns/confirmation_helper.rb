module ConfirmationHelper
  def clean_up_credentials
    where("created_at < ?", Time.now - 3.days).to_a.map(&:destroy)
  end
end