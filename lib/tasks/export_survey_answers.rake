# frozen_string_literal: true

namespace :saas do
  desc "Export and translate answers to surveys"
  task :export_answers, [:survey] => :environment do |t, args|
    export_dir = Rails.root.join("tmp/survey_answers_export")
    FileUtils.mkdir_p export_dir

    export_survey(args.survey, export_dir) unless args.survey.nil?

    organizations = Decidim::Organization.all
    organizations.each do |organization|
      export_surveys_for_organization(organization, export_dir)
    end
  end

  def export_survey(survey_id, export_dir)
    begin
      survey = Decidim::Surveys::Survey.find survey_id
    rescue ActiveRecord::RecordNotFound
      abort "There is no survey with the id #{survey_id}"
    end
    puts "Exporting answers to surveys #{survey_id}"

    path = export_dir.join("survey_#{survey.id}_answers.csv")
    CSV.open(path, "w") do |csv|
      csv << %w(id user_id questionnaire_id question_id ip_hash body)
      questionnaire = survey.questionnaire

      answers = questionnaire.answers
      answers.each do |answer|
        next if answer.body.nil?

        translator = MicrosoftTranslator.new(answer, "body", answer.body, "en", nil)
        puts "Translating content for answer #{answer.id}"
        new_body = translator.translate_content
        sleep 0.5 # Avoid rate limiting

        puts "From #{answer.body} to #{new_body}"

        csv << [answer.id, answer.decidim_user_id, answer.decidim_questionnaire_id, answer.decidim_question_id, answer.ip_hash, new_body]
      end
    end
  end

  def export_surveys_for_organization(organization, export_dir)
    locale = organization.default_locale
    puts "Exporting answers to surveys for organization #{organization.id} - #{organization.name[locale]}"

    surveys = Decidim::Surveys::Survey.all
    surveys.each do |survey|
      next unless survey&.organization&.id == organization.id

      puts "Exporting survey #{survey.id}"

      path = export_dir.join("org_#{organization.id}_survey_#{survey.id}_answers.csv")
      CSV.open(path, "w") do |csv|
        csv << %w(id user_id questionnaire_id question_id ip_hash body)
        questionnaire = survey.questionnaire

        answers = questionnaire.answers
        answers.each do |answer|
          next if answer.body.nil?

          translator = MicrosoftTranslator.new(answer, "body", answer.body, "en", nil)
          puts "Translating content for answer #{answer.id}"
          new_body = translator.translate_content
          sleep 0.5 # Avoid rate limiting

          puts "From #{answer.body} to #{new_body}"

          csv << [answer.id, answer.decidim_user_id, answer.decidim_questionnaire_id, answer.decidim_question_id, answer.ip_hash, new_body]
        end
      end
    end
  end
end
