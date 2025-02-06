# For tuning the Content Security Policy, check the Decidim documentation site
# https://docs.decidim.org/develop/en/customize/content_security_policy
Decidim.configure do |config|
  config.content_security_policies_extra = {
    "connect-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "img-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "default-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "script-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "style-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "font-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "frame-src" => ENV["CONTENT_SECURITY_POLICY"].split,
    "media-src" => ENV["CONTENT_SECURITY_POLICY"].split
  }
end