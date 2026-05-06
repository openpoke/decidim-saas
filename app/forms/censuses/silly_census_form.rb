# frozen_string_literal: true

module Censuses
  # This class presents data for logging into the system with census data.
  class SillyCensusForm < Decidim::Form
    attribute :code, String
    validate :code_unique
    validates :code, presence: true

    def voter_uid
      @voter_uid ||= census_user&.to_global_id&.to_s
    end

    def census_user
      election.census.users(election).where("data->>'code' = ?", code&.strip&.downcase)&.first
    end

    def election
      @election ||= context.election
    end

    private

    def code_unique
      if code&.strip&.present?
        voter = Decidim::Elections::Voter.find_or_create_by(
          election: election,
          data: { code: code.strip.downcase }
        )
        errors.add(:code, "Something went wrong") if voter.blank?
      end
    end
  end
end
