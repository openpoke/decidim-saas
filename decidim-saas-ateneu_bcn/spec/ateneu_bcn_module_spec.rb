# frozen_string_literal: true

require "rails_helper"
require "decidim/saas/ateneu_bcn"

describe "AteneuBcnModule" do
  it "defines the AteneuBcn module" do
    expect(Decidim::Saas::AteneuBcn).to be_a(Module)
  end

  it "defines the AteneuBcn::Engine class as a subclass of Rails::Engine" do
    expect(Decidim::Saas::AteneuBcn::Engine < Rails::Engine).to be true
  end
end
