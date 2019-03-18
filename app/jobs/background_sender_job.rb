class BackgroundSenderJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    callpack_path = ServerXApi::Main::SERVER_X_AUTHID_CALLBACK_PATH
    response = CustomSender.new(SERVER_X_URL + callpack_path).post_data(args)
  end
end
