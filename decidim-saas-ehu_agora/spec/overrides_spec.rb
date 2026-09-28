# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/omniauth_registrations_controller.rb" => "d123849baa422016934a6adb9f05a10a",
      "/app/views/layouts/decidim/_head.html.erb" => "7497bbc152f30dd825de4109afac680a",
      "/app/views/decidim/devise/sessions/new.html.erb" => "da0d18178c8dcead2774956e989527c5",
      "/app/views/decidim/devise/shared/_omniauth_buttons.html.erb" => "688a13e36af349a91e37b04c6caaa3a9",
      "/app/views/decidim/account/show.html.erb" => "1c230c5c6bc02e0bb22e1ea92b0da96c"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    item[:files].each do |file, signature|
      it "#{item[:package]}#{file} matches checksum" do
        gem_dir = Gem::Specification.find_by_name(item[:package]).gem_dir
        expect(md5("#{gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
