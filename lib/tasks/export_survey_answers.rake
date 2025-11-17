# frozen_string_literal: true

namespace :saas do
  desc "Export and translate answers to surveys"
  task :export_answers, [:survey] => :environment do |_t, args|
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
    write_csv(survey, path)
  end

  def export_surveys_for_organization(organization, export_dir)
    locale = organization.default_locale
    puts "Exporting answers to surveys for organization #{organization.id} - #{organization.name[locale]}"

    surveys = Decidim::Surveys::Survey.all
    surveys.each do |survey|
      next unless survey&.organization&.id == organization.id

      puts "Exporting survey #{survey.id}"

      path = export_dir.join("org_#{organization.id}_survey_#{survey.id}_answers.csv")
      write_csv(survey, path)
    end
  end

  def write_csv(survey, path)
    locale = survey.organization.default_locale
    CSV.open(path, "w") do |csv|
      csv << %w(ip_hash user_id user_name survey_id survey_title questionnaire_id
                question_id question_title answer_id
                choice_ids choice_bodies body body_translated)
      questionnaire = survey.questionnaire

      answers = questionnaire.answers
      answers.each do |answer|
        new_body = %w(short_answer long_answer).include?(answer.question.question_type) ? translate_text(answer.body, nil, "en") : ""

        csv << [answer.ip_hash, answer.user&.id, answer.user&.name, survey.id, survey.title[locale], answer.decidim_questionnaire_id,
                answer.question.id, answer.question.body[locale], answer.id,
                answer.choice_ids.join("\n"), answer.choices.map { |c| c.answer_option.body.is_a?(Hash) ? c.answer_option.body[locale] : c.answer_option.body }.join("\n"),
                answer.body, new_body]
      end
    end
  end

  def translate_text(text, from_locale, to_locale)
    return "" if text.blank?

    translator = MicrosoftTranslator.new(nil, nil, text, to_locale, from_locale)
    begin
      new_text = translator.translate_content
      puts "From #{text} to #{new_text}"
    rescue StandardError => e
      puts "TRANSLATION_ERROR: #{e.message} waiting 10 seconds before retrying"
      sleep 10
      retry
    end
    new_text
  end
end
