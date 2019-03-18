config_file = YAML.load_file("config/configs.yml")[Rails.env].deep_symbolize_keys!

 
