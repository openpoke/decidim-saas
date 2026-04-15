# frozen_string_literal: true

module Decidim
  module Saas
    module VivaioDelleIdee
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
          return if profile_incomplete?
          return unless onboarding_survey
          return if permitted_onboarding_survey_path?
          return if user_answered_onboarding_survey?

          store_location_for(
            current_user,
            stored_location_for(current_user) || request.path
          )

          flash[:warning] = t("decidim.saas.vivaio_delle_idee.needs_survey_completed.redirect_message")
          redirect_to onboarding_survey_path
        end

        def profile_incomplete?
          current_organization.respond_to?(:has_required_extra_user_fields?) &&
            current_organization.has_required_extra_user_fields? &&
            !current_organization.extra_user_fields_complete?(current_user)
        end

        def onboarding_survey
          assembly_join = "INNER JOIN decidim_assemblies ON decidim_assemblies.id = decidim_components.participatory_space_id " \
                          "AND decidim_components.participatory_space_type = 'Decidim::Assembly'"
          @onboarding_survey ||= Decidim::Surveys::Survey
                                 .joins(:component)
                                 .joins(assembly_join)
                                 .where.not(decidim_components: { published_at: nil })
                                 .where.not(decidim_assemblies: { published_at: nil })
                                 .where(decidim_assemblies: { decidim_organization_id: current_organization.id })
                                 .order("decidim_components.weight ASC, decidim_surveys_surveys.id ASC")
                                 .first
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
