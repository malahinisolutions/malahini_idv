class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout 'mailer'


  protected

  def attach_logo
    
  end
end
