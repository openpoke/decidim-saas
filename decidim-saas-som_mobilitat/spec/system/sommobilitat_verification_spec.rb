# frozen_string_literal: true

require "rails_helper"

describe "SomMobilitatVerification", with_authorization_workflows: ["sommobilitat_member"] do
  before do
    switch_to_host(organization.host)
  end

  context "when a new user" do
    let(:authorizations) { ["sommobilitat_member"] }
    let(:organization) { create(:organization, available_authorizations: authorizations) }

    let(:user) { create(:user, :confirmed, organization:) }
    let(:api_response1) do
      {
        "count" => 1,
        "rows" => [
          {
            "id" => "123456789",
            "email" => user.email,
            "address" => "Carrer de la Pau, 1",
            "lang" => "ca",
            "name" => "John Doe"
          }
        ]
      }
    end
    let(:api_response2) do
      {
        "count" => 1,
        "rows" => [
          {
            "id" => "123456789",
            "email" => user.email,
            "address" => "Carrer de la Pau, 1",
            "lang" => "ca",
            "name" => "John Doe"
          }
        ]
      }
    end

    before do
      allow_any_instance_of(Saas::SomMobilitat::MemberAuthorizationHandler).to receive(:api_request).and_return(api_response1) # rubocop:disable RSpec/AnyInstance
      visit decidim.root_path
      within "#main-bar" do
        click_on("Log in")
      end

      within "form.new_user", match: :first do
        fill_in :session_user_email, with: user.email
        fill_in :session_user_password, with: "decidim123456789"
        find("*[type=submit]").click
      end
    end

    it "redirects the user to the authorization form after the first sign in" do
      expect(page).to have_content("Simply press the button below to check your membership")
      click_on "Send"
      expect(page).to have_content("You have been successfully authorized")
    end

    context "when email is not found" do
      let(:api_response1) do
        {
          "count" => 0,
          "rows" => []
        }
      end

      it "allows to verify via DNI if the email is not found" do
        click_on "Send"
        expect(page).to have_content("We couldn't automatically find your membership")

        allow_any_instance_of(Saas::SomMobilitat::MemberAuthorizationHandler).to receive(:api_request).and_return(api_response2) # rubocop:disable RSpec/AnyInstance
        fill_in "authorization_handler_dni", with: "123456"
        click_on "Send"
        expect(page).to have_content("You have been successfully authorized")
      end
    end
  end
end
