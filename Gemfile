# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.31-stable" }.freeze
gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-elections", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.31-stable"
gem "decidim-extra_user_fields", github: "openpoke/decidim-module-extra_user_fields", branch: "release/0.31-stable", require: false
gem "decidim-term_customizer", github: "openpoke/decidim-module-term_customizer", branch: "release/0.31-stable"

# Customizations for clients
gem "decidim-saas-clean_clothes", path: "decidim-saas-clean_clothes", require: false
gem "decidim-saas-som_mobilitat", path: "decidim-saas-som_mobilitat", require: false

gem "bootsnap", "~> 1.3"
gem "deface"
gem "health_check"
gem "puma", ">= 6.3.1"
gem "rails_semantic_logger"
gem "sentry-rails"
gem "sentry-ruby"
# because we override the gem, we require it here
gem "aws-sdk-s3" # , require: false
gem "faraday"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "web-console"
end

group :production do
  gem "sidekiq"
  gem "sidekiq-cron"
end
