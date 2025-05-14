# frozen_string_literal: true

require "rails_helper"

describe "CleanClothesModule" do
  it "defines the CleanClothes module" do
    expect(Decidim::Saas::CleanClothes).to be_a(Module)
  end

  it "defines the ExtraUserFields module" do
    expect(Decidim::ExtraUserFields).to be_a(Module)
  end

  it "defines the CleanClothes::Engine class as a subclass of Rails::Engine" do
    expect(Decidim::Saas::CleanClothes::Engine < Rails::Engine).to be true
  end
end
