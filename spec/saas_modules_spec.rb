# frozen_string_literal: true

require "rails_helper"

describe "SaaSModules" do
  it "does not define the CleanClothes module" do
    expect(defined?(Saas::CleanClothes)).to be_nil
  end

  it "does not define the SomMobilitat module" do
    expect(defined?(Saas::SomMobilitat)).to be_nil
  end
end
