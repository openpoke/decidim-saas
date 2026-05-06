Decidim::Elections.census_registry.register(:silly_census) do |manifest|
  manifest.voter_form = "Censuses::SillyCensusForm"
  manifest.voter_form_partial = "censuses/silly_census_form"
  manifest.admin_form = "Censuses::AdminSillyCensusForm"
  manifest.admin_form_partial = "censuses/admin_silly_census_form"

  manifest.user_query do |election|
    Decidim::Elections::Voter.where(election: election)
  end
  manifest.census_ready_validator do |_election|
    true
  end
end
