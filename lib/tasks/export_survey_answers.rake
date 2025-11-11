# frozen_string_literal: true

namespace :saas do
  desc "Export and translate answers to surveys"
  task export_answers: :environment do
    export_dir = Rails.root.join("tmp/survey_answers_export")
    FileUtils.mkdir_p export_dir

    organizations = Decidim::Organization.all
    organizations.each do |organization|
      export_surveys_for_organization(organization, export_dir)
    end
  end

  def export_surveys_for_organization(organization, export_dir)
    path = export_dir.join("#{organization.id}_answers.csv")
    locale = organization.default_locale
    puts "Exporting answers to surveys for organization #{organization.id} - #{organization.name[locale]}"

    CSV.open(path, "w") do |csv|
      csv << %w(id user_id questionnaire_id question_id ip_hash body)
      surveys = Decidim::Surveys::Survey.all
      surveys.each do |survey|
        questionnaire = survey.questionnaire

        answers = questionnaire.answers
        answers.each do |answer|
          next if answer.body.nil?

          translator = MicrosoftTranslator.new(answer, "body", answer.body, "en", nil)
          puts "Translating content for answer #{answer.id}"
          new_body = translator.translate_content

          puts "From #{answer.body} to #{new_body}"

          csv << [answer.id, answer.decidim_user_id, answer.decidim_questionnaire_id, answer.decidim_question_id, answer.ip_hash, new_body]
        end
      end
    end
  end
end
