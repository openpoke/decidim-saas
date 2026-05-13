# frozen_string_literal: true

Decidim.content_blocks.register(:homepage, :vertical_scroll) do |content_block|
  content_block.cell = "decidim/content_blocks/vertical_scroll"
  content_block.public_name_key = "decidim.content_blocks.vertical_scroll.name"
  content_block.settings_form_cell = "decidim/content_blocks/vertical_scroll_settings_form"

  content_block.images = [
    {
      name: :block1_image,
      uploader: "Decidim::HomepageImageUploader"
    },
    {
      name: :block2_image,
      uploader: "Decidim::HomepageImageUploader"
    },
    {
      name: :block3_image,
      uploader: "Decidim::HomepageImageUploader"
    },
    {
      name: :block4_image,
      uploader: "Decidim::HomepageImageUploader"
    },
    {
      name: :block5_image,
      uploader: "Decidim::HomepageImageUploader"
    },
    {
      name: :block6_image,
      uploader: "Decidim::HomepageImageUploader"
    },
    {
      name: :block7_image,
      uploader: "Decidim::HomepageImageUploader"
    }
  ]

  content_block.settings do |settings|
    settings.attribute :title_block1, type: :string
    settings.attribute :description_block1, type: :text, translated: true
    settings.attribute :participate_button_block1_url, type: :string
    settings.attribute :fqa_button_block1_url, type: :string
    settings.attribute :block1_extra_text, type: :string
    settings.attribute :title_block2, type: :string
    settings.attribute :description_block2, type: :text, translated: true
    settings.attribute :title_block3, type: :string
    settings.attribute :description_block3, type: :text, translated: true
    settings.attribute :participate_button_block3_url, type: :string
    settings.attribute :themes_button_block3_url, type: :string
    settings.attribute :title_block4, type: :string
    settings.attribute :description_block4, type: :text, translated: true
    settings.attribute :participate_button_block4_url, type: :string
    settings.attribute :fqa_button_block4_url, type: :string
    settings.attribute :title_block5, type: :string
    settings.attribute :description_block5, type: :text, translated: true
    settings.attribute :title_block6, type: :string
    settings.attribute :description_block6, type: :text, translated: true
    settings.attribute :participate_button_block6_url, type: :string
    settings.attribute :themes_button_block6_url, type: :string
    settings.attribute :title_block7, type: :string
    settings.attribute :description_block7, type: :text, translated: true
    settings.attribute :participate_button_block7_url, type: :string
    settings.attribute :themes_button_block7_url, type: :string
  end

  content_block.default!
end
