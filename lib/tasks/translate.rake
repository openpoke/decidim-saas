# frozen_string_literal: true

namespace :colabs do
  task :translate_all, [:from, :to] => [:environment] do |_, args|
    abort "Please provide the origin and target locales \neg:\n  colabs:translate_all[ca,es]" unless args[:to] && args[:from]
    Zeitwerk::Loader.eager_load_all

    ActiveRecord::Base.descendants.each do |model|
      next unless model.name.start_with?("Decidim::") && model.respond_to?(:translatable_fields_list)
      next unless model.translatable_fields_list.any?

      puts "Translating #{model.name} fields: #{model.translatable_fields_list.join(", ")}"

      begin
        model.find_each do |resource|
          model.translatable_fields_list.each do |field|
            next unless resource[field].is_a?(Hash)

            if resource[field][args[:to]].present?
              puts "Skipping #{model.name}##{resource.id} #{field} because it already has a manual translation"
              next
            end
            if resource[field]["machine_translations"].present? && resource[field]["machine_translations"][args[:to]].present?
              puts "Skipping #{model.name}##{resource.id} #{field} because it already has a machine translation"
              next
            end
            text = resource[field][args[:from]]
            next if text.blank?

            translator = MicrosoftTranslator.new(resource, field, text, args[:to], args[:from])
            puts "Translating #{model.name}##{resource.id} #{field} from #{args[:from]} to #{args[:to]}"

            translator.translate!
            sleep 0.5 # Avoid rate limiting
          end
        end
      rescue ActiveRecord::StatementInvalid => e
        puts "Skipping #{model.name} due to #{e.message}"
      end
    end
  end
end
