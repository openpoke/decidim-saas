# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_saas_ehu_agora: "#{base_path}/app/packs/entrypoints/decidim_saas_ehu_agora.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/saas/ehu_agora/basic_styles")
