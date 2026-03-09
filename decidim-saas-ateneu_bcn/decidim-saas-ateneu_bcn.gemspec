# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

Gem::Specification.new do |s|
  s.version = "1.0"
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@pokecode.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/openpoke/decidim-saas"
  s.required_ruby_version = ">= 3.3"

  s.name = "decidim-saas-ateneu_bcn"
  s.summary = "Extras for  Ateneu Barcelonès Decidim instance."
  s.description = "Ateneu Barcelonès Decidim instance with some extra features."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
end
