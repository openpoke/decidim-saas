# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.28-stable" }
gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome", branch: "release/0.28-stable"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "main"

gem "bootsnap", "~> 1.3"
gem "health_check"
gem "puma", ">= 6.3.1"
gem "rorvswild"
gem "active_hashcash"
gem "rails_semantic_logger"
gem "deface"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  
  gem "brakeman", "~> 6.1"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "aws-sdk-s3" #, require: false
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end

group :production do
  gem "aws-sdk-s3" #, require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
