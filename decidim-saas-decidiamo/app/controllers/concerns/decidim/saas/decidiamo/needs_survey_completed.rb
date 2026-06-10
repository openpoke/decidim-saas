# frozen_string_literal: true

module Decidim
  module Saas
    module Decidiamo
      module NeedsSurveyCompleted
        extend ActiveSupport::Concern

        included do
          before_action :onboarding_survey_completed_by_user
        end

        private

        def onboarding_survey_completed_by_user
          return unless request.format.html?
          return unless current_user
          return unless current_user.tos_accepted?
          return unless onboarding_survey
          return if permitted_onboarding_survey_path?
          return if user_answered_onboarding_survey?

          store_location_for(
            current_user,
            stored_location_for(current_user) || request.path
          )

          flash[:warning] = t("decidim.saas.decidiamo.needs_survey_completed.redirect_message")
          redirect_to onboarding_survey_path
        end

        def onboarding_survey
          @onboarding_survey ||= Decidim::Surveys::Survey.find_by(id: ENV.fetch("ONBOARDING_SURVEY_ID", nil))
        end

        def onboarding_survey_path
          Decidim::EngineRouter.main_proxy(onboarding_survey.component).survey_path(onboarding_survey)
        end

        def user_answered_onboarding_survey?
          return true unless onboarding_survey.questionnaire

          onboarding_survey.questionnaire.responded_by?(current_user)
        end

        def permitted_onboarding_survey_path?
          return true if request.path.start_with?(onboarding_survey_path)
          return true if request.path.start_with?(decidim.download_your_data_path.split("?").first)

          permitted_paths = [
            decidim.account_path,
            decidim.delete_account_path,
            decidim.destroy_user_session_path,
            decidim.accept_tos_path
          ]

          permitted_paths.find { |el| el.split("?").first == request.path }
        end
      end
    end
  end
end
