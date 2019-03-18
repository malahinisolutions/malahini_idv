config_file = File.open(File.join(Rails.root, "config", "secret_key.yml"))
config = YAML::load(config_file)[Rails.env].symbolize_keys

SECRET_KEY = config[:secret_key]