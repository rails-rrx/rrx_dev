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
end
