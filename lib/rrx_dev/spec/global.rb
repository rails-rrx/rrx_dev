require 'active_support/testing/assertions'
require 'rspec/parameterized'

module Global
  def self.included(other)
    other.let(:json_body) do
      JSON.parse(response.body, object_class: HashWithIndifferentAccess)
    end

    other.let(:json_response) do
      expect(response).to be_successful
      json_body
    end

    other.let(:json_error) do
      expect(response).not_to be_successful
      json_body
    end

  end
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::Assertions
  config.include Global

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

