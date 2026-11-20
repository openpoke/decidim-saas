# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "/sitemap.xml", to: proc { [404, {}, [""]] }

  get "/.well-known/security.txt", to: proc {
    content = <<~TEXT
      Contact: security@pokecode.net
      Expires: #{1.year.from_now.to_date}
      Preferred-Languages: en, ca, es
    TEXT
    [200, { "Content-Type" => "text/plain" }, [content]]
  }

  mount Decidim::Core::Engine => "/"
end
