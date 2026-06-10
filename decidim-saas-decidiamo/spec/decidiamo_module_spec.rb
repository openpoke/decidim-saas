# frozen_string_literal: true

require "rails_helper"
require "decidim/saas/decidiamo"

describe "DecidiamoModule" do
  it "defines the Decidiamo module" do
    expect(Decidim::Saas::Decidiamo).to be_a(Module)
  end

  it "defines the Decidiamo::Engine class as a subclass of Rails::Engine" do
    expect(Decidim::Saas::Decidiamo::Engine < Rails::Engine).to be true
  end
end
