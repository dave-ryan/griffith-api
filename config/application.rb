require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SecretSanta
  class Application < Rails::Application
    # API only
    config.api_only = true
    config.debug_exception_response_format = :api

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Load my own middleware
    Dir[Rails.root.join("lib", "middleware", "*.{rb}")].each { |file| require file }

    # Add own middleware for catching errors
    config.middleware.use Middleware::CatchRackErrors

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
