# frozen_string_literal: true

# Shared context: auth_helpers
# Provides test authentication helpers for request specs.
#
# Usage:
#   RSpec.describe 'Posts', type: :request do
#     include_context :auth_helpers
#     authenticated!
#
#     it 'returns posts' do
#       get '/posts', headers: request_headers
#       expect(response).to be_successful
#     end
#   end
#
# By default +authenticated!+ sets +X-Test-User-Id+ from the +user+ let.
# Pass a different let name if needed:
#   authenticated! user_let: :admin_user
RSpec.shared_context :auth_helpers do
  let(:auth_headers)    { {} }
  let(:request_headers) { {}.merge!(auth_headers) }

  def self.authenticated!(user_let: :user)
    before do
      auth_headers['X-Test-User-Id'] = send(user_let).id
    end
  end
end
