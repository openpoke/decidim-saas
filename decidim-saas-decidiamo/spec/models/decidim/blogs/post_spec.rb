# frozen_string_literal: true

require "rails_helper"
require "decidim/assemblies/test/factories"
require "decidim/blogs/test/factories"

describe Decidim::Blogs::Post do
  subject(:post) { create(:post, title: { "en" => title }, component:) }

  let(:organization) { create(:organization, default_locale: "en", available_locales: ["en"]) }
  let(:participatory_space) { create(:assembly, organization:) }
  let(:component) { create(:post_component, participatory_space:) }
  let(:title) { "Le migliori 280 idee di Sant Jordi per la città" }

  describe "#to_param" do
    it "starts with the post ID" do
      expect(post.to_param).to match(/\A\d+-/)
    end

    it "contains the parameterized title" do
      expect(post.to_param).to end_with("-le-migliori-280-idee-di-sant-jordi-per-la-citta")
    end

    it "has the format id-title-slug" do
      expect(post.to_param).to eq("#{post.id}-le-migliori-280-idee-di-sant-jordi-per-la-citta")
    end

    it "appears in the post URL" do
      url = Decidim::EngineRouter.main_proxy(component).post_path(post)
      expect(url).to include("le-migliori-280-idee-di-sant-jordi-per-la-citta")
      expect(url).to match(%r{/posts/\d+-})
    end
  end
end
