# frozen_string_literal: true

def init_rrx_spec_rails!
  loading_helper = caller_locations.find { |loc| loc.path.match?(/[\\\/](spec|rails)_helper.rb/) }
  raise 'rrx_dev/spec must be required by spec_helper.rb or rails_helper.rb' unless loading_helper

  spec_dir = Pathname.new(loading_helper.path).dirname.freeze
  app_env  = (spec_dir.glob('*/config/environment.rb').first || spec_dir.join('../config/environment.rb')).freeze
  raise "Could not find Rails environment file" unless app_env.exist?

  puts "Loading Rails environment from #{app_env}" if ENV['DEBUG']

  ENV['RAILS_ENV'] ||= 'test'
  require app_env.expand_path.to_s

  # Prevent database truncation if the environment is production
  abort('The Rails environment is running in production mode!') if Rails.env.production?

  require 'rspec/rails'

  if defined?(ActiveRecord)
    begin
      ActiveRecord::Migration.maintain_test_schema!
    rescue ActiveRecord::PendingMigrationError => e
      Rails.logger.debug e.to_s.strip
      exit 1 # rubocop:disable Rails/Exit
    end
  end

  # Use spec_dir (the caller's spec/ directory) instead of Rails.root,
  # because Rails.root resolves to spec/dummy which is inside spec/.
  Dir[spec_dir.join('support/**/*.rb')].sort.each { |f| require f }
end

init_rrx_spec_rails!

RSpec.configure do |config|
  config.render_views               = true
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

