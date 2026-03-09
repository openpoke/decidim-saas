# frozen_string_literal: true

require "rails_helper"

describe "Account" do
  let(:user) { create(:user, :confirmed, password:) }
  let!(:identity) { create(:identity, user:, provider: "saml") }
  let(:password) { "dqCFgjfDbC7dPbrv" }
  let(:organization) { user.organization }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.account_path
  end

  describe "updating personal data" do
    let!(:encrypted_password) { user.encrypted_password }

    it "updates the user's data" do
      within "form.edit_user" do
        select "Castellano", from: :user_locale
        fill_in :user_name, with: "Nikola Tesla"
        fill_in :user_personal_url, with: "https://example.org"
        fill_in :user_about, with: "A Serbian-American inventor, electrical engineer, mechanical engineer, physicist, and futurist."

        expect(page).to have_no_field("user[name]", with: "Nikola Tesla", readonly: true)
        expect(page).to have_field("user[name]", with: user.name, readonly: true)
        expect(page).to have_field("user[email]", with: user.email, readonly: true)
        expect(page).to have_field("user[nickname]", with: user.nickname, readonly: true)
        expect(page).to have_no_link("Change password")
        expect(page).to have_no_field("user[password]", with: "", type: "password")

        all("*[type=submit]").last.click
      end

      expect(page).to have_content("Your account was successfully updated.")

      user.reload

      within_user_menu do
        find("a", text: "perfil público").click
      end

      expect(page).to have_no_content("Nikola Tesla")
      expect(page).to have_content("example.org")
      expect(page).to have_content("Serbian-American")

      # The user's password should not change when they did not update it
      expect(user.reload.encrypted_password).to eq(encrypted_password)
    end
  end
end
