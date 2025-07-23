# frozen_string_literal: true

require 'rails_helper'
require 'didja_rails/rswag'

swagger do
  # List Swagger documents that will be generates by specs/integration tests
  # NOTE: This MUST be kept in sync with config/initializers/api_docs.rb

  # Add reusable schemas as additional hash parameters
  #
  # Example
  #   doc 'v2/swagger.yaml', 'API v1', 'v1',
  #     my_type: object(
  #       prop_one: string
  #     ),
  #     other_type: object(
  #       prop_two: integer
  #     )
  #
  doc 'v1/swagger.yaml', 'API v1', 'v1'

  # Add more docs for additional API versions
  #
  # doc 'v2/swagger.yaml', 'API v2', 'v2'
end
