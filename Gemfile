# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "~> 0.28.0"
gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-templates", DECIDIM_VERSION

gem "decidim-decidim_awesome"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "main"

gem "bootsnap", "~> 1.3"
gem "health_check"
gem "puma", ">= 6.3.1"
gem "wicked_pdf", "~> 2.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  
  gem "brakeman", "~> 6.1"
  gem "decidim-dev", DECIDIM_VERSION
  gem "net-imap", "~> 0.2.3"
  gem "net-pop", "~> 0.1.1"
  gem "net-smtp", "~> 0.3.1"
end

group :development do
  gem "aws-sdk-s3"#, require: false
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "web-console", "~> 4.2"
end

group :production do
  gem "aws-sdk-s3"#, require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
