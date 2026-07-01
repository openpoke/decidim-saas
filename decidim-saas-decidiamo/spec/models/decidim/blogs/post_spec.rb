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

    context "when the title produces a slug longer than 100 characters" do
      let(:title) { "Le migliori trecento idee innovative per trasformare la città di Milano in una metropoli sostenibile e moderna" }

      it "truncates the slug to 100 characters" do
        slug = post.to_param.sub(/\A\d+-/, "")
        expect(slug.length).to be <= 100
      end

      it "truncates without cutting mid-word abruptly (no trailing dash)" do
        slug = post.to_param.sub(/\A\d+-/, "")
        expect(slug).to eq("le-migliori-trecento-idee-innovative-per-trasformare-la-citta-di-milano-in-una-metropoli-sostenibile")
      end
    end

    context "when the title produces a slug of exactly 99 characters" do
      let(:title) { "Caporalato in agricoltura: perché serve una filiera agroalimentare trasparente dal campo alla tavola" }

      it "does not truncate the slug" do
        slug = post.to_param.sub(/\A\d+-/, "")
        expect(slug).to eq("caporalato-in-agricoltura-perche-serve-una-filiera-agroalimentare-trasparente-dal-campo-alla-tavola")
        expect(slug.length).to eq(99)
      end
    end
  end
end
