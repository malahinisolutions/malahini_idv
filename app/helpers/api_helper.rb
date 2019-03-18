module ApiHelper

  ATENCOIN_URL_PATTERN = "http://%s:%s@%s"

  def atencoin_url
    ATENCOIN_URL_PATTERN % [ATENCOIN_USERNAME, ATENCOIN_PASSWORD, ATENCOIN_ADDRESS]
  end
end
