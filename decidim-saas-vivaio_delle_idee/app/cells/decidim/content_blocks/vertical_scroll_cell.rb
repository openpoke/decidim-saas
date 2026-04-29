# frozen_string_literal: true

module Decidim
  module ContentBlocks
    class VerticalScrollCell < Decidim::ViewModel
      def title_block1
        model.settings.title_block1
      end

      def description_block1
        translated_attribute model.settings.description_block1
      end

      def block1_extra_text
        model.settings.block1_extra_text
      end

      def title_block2
        model.settings.title_block2
      end

      def description_block2
        translated_attribute model.settings.description_block2
      end

      def title_block3
        model.settings.title_block3
      end

      def description_block3
        translated_attribute model.settings.description_block3
      end

      def title_block4
        model.settings.title_block4
      end

      def description_block4
        translated_attribute model.settings.description_block4
      end

      def title_block5
        model.settings.title_block5
      end

      def description_block5
        translated_attribute model.settings.description_block5
      end

      def title_block5
        model.settings.title_block5
      end

      def description_block5
        translated_attribute model.settings.description_block5
      end

      def title_block6
        model.settings.title_block6
      end

      def description_block6
        translated_attribute model.settings.description_block6
      end

      def title_block7
        model.settings.title_block7
      end

      def description_block7
        translated_attribute model.settings.description_block7
      end

      def block1_image
        model.images_container.attached_uploader(:block1_image).path
      end

      def block2_image
        model.images_container.attached_uploader(:block2_image).path
      end

      def block4_image
        model.images_container.attached_uploader(:block4_image).path
      end

      def block5_image
        model.images_container.attached_uploader(:block5_image).path
      end

      def block7_image
        model.images_container.attached_uploader(:block7_image).path
      end
    end
  end
end
