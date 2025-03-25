# For tuning the Content Security Policy, check the Decidim documentation site
# https://docs.decidim.org/develop/en/customize/content_security_policy
Rails.application.config.to_prepare do
  Decidim.configure do |config|
    # TODO: simplify when https://github.com/decidim/decidim/pull/14391 is backported
    config.content_security_policies_extra = {
      "connect-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      "img-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      "default-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      "script-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      "style-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      "font-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      # "frame-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split,
      "frame-src" => config.content_security_policies_extra["frame-src"].concat(ENV.fetch("CONTENT_SECURITY_POLICY","").split),
      "media-src" => ENV.fetch("CONTENT_SECURITY_POLICY","").split
    }
  end
end