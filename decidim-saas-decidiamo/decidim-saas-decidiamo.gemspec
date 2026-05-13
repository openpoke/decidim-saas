# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.version = "1.0"
  s.authors = ["Elvia Benedith"]
  s.email = ["elvia@pokecode.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/openpoke/decidim-saas"
  s.required_ruby_version = ">= 3.3"

  s.name = "decidim-saas-decidiamo"
  s.summary = "Extras for Decidiamo Decidim instance."
  s.description = "Decidiamo Decidim instance with some extra features."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
end
