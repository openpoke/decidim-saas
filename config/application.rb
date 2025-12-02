# frozen_string_literal: true

require_relative "boot"

require "decidim/rails"

# Add the frameworks used by your app that are not loaded by Decidim.
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Require the gems listed in Gemfile with require=false if env var present
# require "decidim/extra_user_fields" if ENV["WITH_EXTRA_USER_FIELDS"].present? && ENV["WITH_CLEAN_CLOTHES"].blank?
require "decidim/saas/clean_clothes" if ENV["WITH_CLEAN_CLOTHES"].present?
require "decidim/saas/som_mobilitat" if ENV["WITH_SOM_MOBILITAT"].present?

module DecidimSaas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
