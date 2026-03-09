# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "openpoke/decidim", branch: "0.31-backports" }.freeze
gem "decidim", DECIDIM_VERSION
gem "decidim-collaborative_texts", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-elections", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-chatbot", github: "openpoke/decidim-module-chatbot", require: false
gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "main"
gem "decidim-extra_censuses", github: "openpoke/decidim-module-extra_censuses", branch: "main"
gem "decidim-extra_user_fields", github: "openpoke/decidim-module-extra_user_fields", require: false
gem "decidim-pokecode", github: "openpoke/decidim-module-pokecode", branch: "fix/logger_appenders"
gem "decidim-term_customizer", github: "openpoke/decidim-module-term_customizer", branch: "main"

# Customizations for clients
gem "decidim-saas-clean_clothes", path: "decidim-saas-clean_clothes", require: false
gem "decidim-saas-ehu_agora", path: "decidim-saas-ehu_agora", require: false
gem "decidim-saas-som_mobilitat", path: "decidim-saas-som_mobilitat", require: false

gem "bootsnap", "~> 1.3"
gem "faraday"
gem "puma", ">= 6.3.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "web-console"
end
