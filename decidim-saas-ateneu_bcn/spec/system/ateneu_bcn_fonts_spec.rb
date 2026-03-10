# frozen_string_literal: true

require "rails_helper"

describe "AteneuBcnFonts" do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "loads the custom fonts stylesheet" do
    expect(page.execute_script("return window.getComputedStyle(document.getElementsByTagName('body')[0]).fontFamily")).to eq("ppEiko, theFutureBlack, Roboto, sans-serif")
  end
end
