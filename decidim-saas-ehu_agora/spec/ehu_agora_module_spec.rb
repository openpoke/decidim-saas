# frozen_string_literal: true

require "rails_helper"

describe "EhuAgoraModule" do
  it "defines the EhuAgora module" do
    expect(Decidim::Saas::EhuAgora).to be_a(Module)
  end

  it "defines the EhuAgora::Engine class as a subclass of Rails::Engine" do
    expect(Decidim::Saas::EhuAgora::Engine < Rails::Engine).to be true
  end
end
