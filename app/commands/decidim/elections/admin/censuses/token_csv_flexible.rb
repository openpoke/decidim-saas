# frozen_string_literal: true

module Decidim
  module Elections
    module Admin
      module Censuses
        class TokenCsvFlexible < TokenCsv
          def call
            return broadcast(:invalid) if @form.invalid?
            return broadcast(:invalid) if @form.remove_all && @election.census.blank?

            if @form.remove_all
              @election.voters.delete_all
              return broadcast(:ok)
            end

            return broadcast(:invalid) unless @form.file

            rows = @form.data
            return broadcast(:invalid) if rows.blank?

            # Store as id + token (not email)
            Voter.bulk_insert(@election, rows.map { |row| { id: row.first, token: row.second } })
            broadcast(:ok)
          end
        end
      end
    end
  end
end
