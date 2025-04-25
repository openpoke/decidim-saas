# frozen_string_literal: true

Decidim::Verifications.register_workflow(:sommobilitat_member) do |auth|
  auth.form = "SomMobilitat::MemberAuthorizationHandler"
  auth.renewable = true
  auth.time_between_renewals = 1.hour
end
