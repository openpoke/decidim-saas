# frozen_string_literal: true

require "rails_helper"

describe "Conferences Homepage" do
  let!(:organization) { create(:organization) }
  let!(:conference_city) { create(:conference, :published, promoted: false, organization:) }

  before do
    organization.update(
      twitter_handler: "twitter_handler",
      facebook_handler: "facebook_handler",
      youtube_handler: "youtube_handler",
      github_handler: "github_handler"
    )

    switch_to_host(organization.host)
    visit decidim_conferences.conferences_path
  end

  context "when homepage footer has organization logos" do
    it "includes the organization logo as its content" do
      expect(page).to have_css(".main-footer__down")

      within ".main-footer__top" do
        expect(page).to have_css(".footer-logo")
        expect(page).to have_css(".logos")
      end
    end
  end

  it "includes the links to social networks" do
    expect(page).to have_xpath("//a[@href = 'https://twitter.com/twitter_handler']")
    expect(page).to have_xpath("//a[@href = 'https://www.facebook.com/facebook_handler']")
    expect(page).to have_xpath("//a[@href = 'https://www.youtube.com/youtube_handler']")
    expect(page).to have_xpath("//a[@href = 'https://www.github.com/github_handler']")
  end
end
