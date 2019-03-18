config_file = File.open(File.join(Rails.root, "config", "recaptcha_keys.yml"))
config = YAML::load(config_file)[Rails.env].symbolize_keys

ENV['RECAPTCHA_PUBLIC_KEY'] = config[:public_key]
ENV['RECAPTCHA_PRIVATE_KEY'] = config[:private_key]
