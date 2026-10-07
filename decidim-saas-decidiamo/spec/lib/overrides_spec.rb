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
      "/app/views/layouts/decidim/_head.html.erb" => "7497bbc152f30dd825de4109afac680a",
      "/app/views/decidim/devise/omniauth_registrations/new.html.erb" => "dc4017744f7aac56f0b7db9ded26677d",
      "/app/views/decidim/devise/registrations/new.html.erb" => "4a64a07b83678fa5360ded05e2bfd96c",
      "/app/cells/decidim/content_blocks/hero/show.erb" => "85d3a88758fb689681e3210d01f39ea1",
      "/app/cells/decidim/content_blocks/hero/cta_button.erb" => "60210020a582198f0048d9c3890f552c",
      "/app/cells/decidim/content_blocks/hero_settings_form/show.erb" => "943344f24ba9c8a6129bafdcf0e0fce3",
      "/app/views/layouts/decidim/header/_main.html.erb" => "2808459045fd14b7f8d689fbbd6dfa4e"
    }
  },
  {
    package: "decidim-blogs",
    files: {
      "/app/views/decidim/blogs/posts/index.html.erb" => "aa6222aa7e3cfccde6ad913cc754e2a1",
      "/app/views/decidim/blogs/posts/_posts.html.erb" => "b84bf413cf3a30e2225ed4105cca4976"
    }
  },
  {
    package: "decidim-extra_user_fields",
    files: {
      "/app/views/decidim/extra_user_fields/_registration_form.html.erb" => "6820fbd845baba6477dc791c43884b6a",
      "/app/views/decidim/extra_user_fields/_select_fields.html.erb" => "a14c916ddae060e3ada91a41988cffff"
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
