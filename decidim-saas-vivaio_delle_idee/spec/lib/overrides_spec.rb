# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_head.html.erb" => "0faa190f7a4b3db401ffcdfc3d063802",
      "/app/views/decidim/devise/omniauth_registrations/new.html.erb" => "b972ec211ff96702d449cf6c8846a613",
      "/app/views/decidim/devise/registrations/new.html.erb" => "861b8821bbdc05e7b337fcdb921415ba",
      "/app/cells/decidim/content_blocks/hero/show.erb" => "85d3a88758fb689681e3210d01f39ea1",
      "/app/cells/decidim/content_blocks/hero/cta_button.erb" => "60210020a582198f0048d9c3890f552c",
      "/app/cells/decidim/content_blocks/hero_settings_form/show.erb" => "7eeb24f48f72cf2cb67a58ac9f621ad3",
      "/app/views/layouts/decidim/header/_main.html.erb" => "a090eeca739613446d2eab8f4de513b1"
    }
  },
  {
    package: "decidim-extra_user_fields",
    files: {
      "/app/views/decidim/extra_user_fields/_registration_form.html.erb" => "e649578ea693f666e94897deefc52069",
      "/app/views/decidim/extra_user_fields/_select_fields.html.erb" => "a14c916ddae060e3ada91a41988cffff"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
