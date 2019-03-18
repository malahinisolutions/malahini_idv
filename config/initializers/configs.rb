config_file = YAML.load_file("config/configs.yml")[Rails.env].deep_symbolize_keys!

SERVER_X_KEY = config_file[:server_x][:key]
SERVER_X_URL = config_file[:server_x][:url]
SERVER_X_IV = config_file[:server_x][:iv]

EMAIL_FROM = config_file[:mail_smtp_conf][:user_name]



TEMP_USER_DAYS_COUNT = config_file[:accounts][:days_without_id_verification]

ACCOUNT_CREDENTIALS_KEY = config_file[:account_credentials_key]

CURRENT_WALLET_VERSION = config_file[:current_wallet_version]

 
