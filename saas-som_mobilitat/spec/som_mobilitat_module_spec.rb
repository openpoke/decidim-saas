# frozen_string_literal: true

require "rails_helper"

describe "SomMobilitatModule" do
  it "defines the SomMobilitat module" do
    expect(Saas::SomMobilitat).to be_a(Module)
  end

  it "defines the SomMobilitat::Engine class as a subclass of Rails::Engine" do
    expect(Saas::SomMobilitat::Engine < Rails::Engine).to be true
  end
end
