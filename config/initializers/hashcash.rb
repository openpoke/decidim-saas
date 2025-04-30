# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveHashcash.class_eval do
    def hashcash_bits
      bits = ActiveHashcash.bits
      if defined?(controller_name) && controller_name == "sessions"
        bits -= 3 # Lower the bits for the login form
      end
      if (previous_stamp_count = ActiveHashcash::Stamp.where(ip_address: hashcash_ip_address).where(created_at: 1.day.ago..).count).positive?
        (bits + Math.log2(previous_stamp_count)).floor
      else
        bits
      end
    end

    def self.bits
      ENV.fetch("HASHCASH_BITS", 19).to_i
    end
  end
  Decidim::Devise::SessionsController.include(ActiveHashcash)
  Decidim::Devise::RegistrationsController.include(ActiveHashcash)

  unless Rails.env.test?
    Decidim::Devise::SessionsController.class_eval do
      before_action :check_hashcash, only: :create
    end

    Decidim::Devise::RegistrationsController.class_eval do
      before_action :check_hashcash, only: :create
    end
  end
end
