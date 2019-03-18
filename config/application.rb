require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'net/http'
require 'uri'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Www
  class Application < Rails::Application
		config.autoload_paths += %W(#{config.root}/app/middlewares)
    config.autoload_paths << Rails.root.join('lib', 'ext')
    config.force_ssl = true
    Dir[File.join(Rails.root, "lib", "ext", "*.rb")].each {|l| require l }

    config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
    config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
    # config.assets.precompile += [/.*\.js/,/.*\.css/,/.*\.gif/, /.*\.png/]
    config.assets.precompile += [/.*\.js/,/.*\.gif/,/.*\.png/]

    config.active_record.raise_in_transactional_callbacks = true

    config.action_controller.include_all_helpers = true

    config_file = YAML.load_file("config/configs.yml")[Rails.env]

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings =
    {
                     address: config_file["mail_smtp_conf"]["address"],
                        port: config_file["mail_smtp_conf"]["port"],
                      domain: config_file["mail_smtp_conf"]["domain"],
                   user_name: config_file["mail_smtp_conf"]["user_name"],
                    password: config_file["mail_smtp_conf"]["password"],
              authentication: config_file["mail_smtp_conf"]["authentication"],
        enable_starttls_auto: config_file["mail_smtp_conf"]["enable_starttls_auto"]
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
