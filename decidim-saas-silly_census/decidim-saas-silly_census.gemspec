# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.version = "1.0"
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@pokecode.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/openpoke/decidim-saas"
  s.required_ruby_version = ">= 3.3"

  s.name = "decidim-saas-silly_census"
  s.summary = "Adds a demo census for Decidim elections"
  s.description = "Silly Census is a Decidim module that adds a demo census for Decidim elections. It is used for testing and demonstration purposes."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
end
