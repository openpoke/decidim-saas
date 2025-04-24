# frozen_string_literal: true

# NOTE: Remove when upgrading to v0.30

module Decidim
  module Debates
    # This cell renders the Grid (:g) debate card
    # for a given instance of a Debate
    class DebateGCell < Decidim::CardGCell
      def show
        render
      end

      private

      def show_description?
        true
      end

      def metadata_cell
        "decidim/debates/debate_metadata_g"
      end
    end
  end
end