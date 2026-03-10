# frozen_string_literal: true

require "rails_helper"
require "decidim/extra_user_fields" if ENV["WITH_EXTRA_USER_FIELDS"].present?

describe "SaaSModules" do
  it "does not define the CleanClothes module" do
    expect(defined?(Decidim::Saas::CleanClothes)).to be_nil
  end

  it "does not define the SomMobilitat module" do
    expect(defined?(Decidim::Saas::SomMobilitat)).to be_nil
  end

  it "does not define the EhuAgora module" do
    expect(defined?(Decidim::Saas::EhuAgora)).to be_nil
  end

  if ENV["WITH_EXTRA_USER_FIELDS"].present?
    it "defines the ExtraUserFields module" do
      expect(Decidim::ExtraUserFields).to be_a(Module)
    end
  else
    it "does not define the ExtraUserFields module" do
      expect(defined?(Decidim::ExtraUserFields)).to be_nil
    end
  end

  if ENV["WITH_CHATBOT"].present?
    it "defines the Chatbot module" do
      expect(Decidim::Chatbot).to be_a(Module)
    end
  else
    it "does not define the Chatbot module" do
      expect(defined?(Decidim::Chatbot)).to be_nil
    end
  end
end
