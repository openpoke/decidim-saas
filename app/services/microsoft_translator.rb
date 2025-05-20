# frozen_string_literal: true

class MicrosoftTranslator
  attr_reader :text, :source_locale, :target_locale, :resource, :field_name

  def initialize(resource, field_name, text, target_locale, source_locale)
    @resource = resource
    @field_name = field_name
    @text = text
    @target_locale = target_locale
    @source_locale = source_locale
  end

  def translate
    Decidim::MachineTranslationSaveJob.perform_later(
      resource,
      field_name,
      target_locale,
      translate_content
    )
  end

  def translate!
    Decidim::MachineTranslationSaveJob.perform_now(
      resource,
      field_name,
      target_locale,
      translate_content
    )
  end

  def translate_content
    @translate_content ||= begin
      result = api.post("translate", [{ "Text" => @text }].to_json)
      body = JSON.parse(result.body).first
      if body.first == "error"
        Rails.logger.error("Microsoft Translator API error: #{body.second}")
        raise StandardError, body
      else
        body["translations"].first["text"]
      end
    end
  end

  def api
    @api ||= Faraday.new(
      url: Decidim::Env.new("TRANSLATOR_ENDPOINT", "https://api.cognitive.microsofttranslator.com/").to_s,
      params: {
        "api-version" => "3.0",
        "from" => @source_locale,
        "to" => @target_locale
      },
      headers: {
        "Ocp-Apim-Subscription-Key" => ENV.fetch("TRANSLATOR_API_KEY", nil),
        "Ocp-Apim-Subscription-Region" => Decidim::Env.new("TRANSLATOR_REGION", "westeurope").to_s,
        "Content-Type" => "application/json"
      }
    )
  end
end
