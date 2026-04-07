# frozen_string_literal: true

require "rails_helper"
require "decidim/saas/vivaio_delle_idee"

describe "VivaioDelleIdeeModule" do
  it "defines the VivaioDelleIdee module" do
    expect(Decidim::Saas::VivaioDelleIdee).to be_a(Module)
  end

  it "defines the VivaioDelleIdee::Engine class as a subclass of Rails::Engine" do
    expect(Decidim::Saas::VivaioDelleIdee::Engine < Rails::Engine).to be true
  end
end
