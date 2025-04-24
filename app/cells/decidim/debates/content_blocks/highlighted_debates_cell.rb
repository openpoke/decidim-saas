# frozen_string_literal: true

# NOTE: Remove when upgrading to v0.30

module Decidim
  module Debates
    module ContentBlocks
      class HighlightedDebatesCell < Decidim::ContentBlocks::HighlightedElementsCell
        def show
          render unless items_count.zero?
        end

        private

        def debates
          @debates ||= Decidim::Debates::Debate.open.where(component: published_components).order(Decidim::Debates::Debate.arel_table[:updated_at].desc)
        end

        def decidim_debates
          return unless single_component

          Decidim::EngineRouter.main_proxy(single_component)
        end

        def single_component
          @single_component ||= published_components.one? ? published_components.first : nil
        end

        def debates_to_render
          @debates_to_render ||= debates.includes([:author, :component]).limit(limit)
        end

        def items_count
          debates_to_render.size
        end

        def cache_hash
          hash = []
          hash << "decidim/debates/content_blocks/highlighted_debates"
          hash << debates.cache_key_with_version
          hash << I18n.locale.to_s
          hash.join(Decidim.cache_key_separator)
        end

        def limit
          6
        end
      end
    end
  end
end
