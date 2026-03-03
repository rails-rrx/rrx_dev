# frozen_string_literal: true

require 'rrx_dev/spec/auth_helpers'

RSpec.describe 'auth_helpers shared context' do
  include_context :auth_helpers

  let(:user) { double('User', id: 'user-99') }

  describe 'default state' do
    it 'has empty auth_headers by default' do
      expect(auth_headers).to be_empty
    end

    it 'has empty request_headers by default' do
      expect(request_headers).to be_empty
    end
  end

  describe 'authenticated! class method' do
    context 'when called with default user_let: :user' do
      authenticated!

      it 'sets X-Test-User-Id in auth_headers' do
        expect(auth_headers['X-Test-User-Id']).to eq 'user-99'
      end

      it 'merges the auth_headers into request_headers' do
        expect(request_headers['X-Test-User-Id']).to eq 'user-99'
      end
    end

    context 'when called with a custom user_let' do
      let(:admin) { double('Admin', id: 'admin-1') }

      authenticated! user_let: :admin

      it 'reads the id from the named let' do
        expect(auth_headers['X-Test-User-Id']).to eq 'admin-1'
      end
    end
  end
end
