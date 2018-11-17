# frozen_string_literal: true

require "factory_bot"
require "factory_bot_rails/generator"
require "rails"

module FactoryBot
  class Railtie < Rails::Railtie
    initializer "factory_bot.set_fixture_replacement" do
      FactoryBotRails::Generator.new(config).run
    end

    initializer "factory_bot.set_factory_paths" do
      FactoryBot.definition_file_paths = [
        Rails.root.join("factories"),
        Rails.root.join("spec", "factories")
      ]
    end

    config.after_initialize do
      # This line is the one that fixes Doorkeeper classes in factories
      ActiveSupport.on_load(:active_record) { FactoryBot.find_definitions }

      Spring.after_fork { FactoryBot.reload } if defined?(Spring)
    end
  end
end
