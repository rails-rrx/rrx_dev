# frozen_string_literal: true

require 'rrx_dev/spec/matchers'
require 'active_model'

# A minimal ActiveModel class to exercise the matchers.
class DummyModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name,   :string
  attribute :score,  :integer, default: 0
  # raw_score is untyped so numericality validation fires on non-numeric strings
  attribute :raw_score, :string
  attribute :color,  :string

  validates :name, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0 }
  validates :raw_score, numericality: true, allow_blank: true
  validates :color, absence: true, if: -> { color == 'red' }
end

RSpec.describe 'error_matcher shared context' do
  include_context :error_matcher

  subject(:model) { DummyModel.new }

  describe 'verify(:attribute).present' do
    it 'passes when the attribute is blank' do
      expect(model).to verify(:name).present
    end

    it 'fails when the attribute has a value' do
      model.name = 'Alice'
      expect(model).not_to verify(:name).present
    end
  end

  describe 'verify(:attribute).numeric' do
    it 'passes when a non-numeric string is in a numericality-validated attribute' do
      model.raw_score = 'abc'
      expect(model).to verify(:raw_score).numeric
    end

    it 'fails when the attribute contains a valid number' do
      model.raw_score = '5'
      expect(model).not_to verify(:raw_score).numeric
    end
  end

  describe 'verify(:attribute).positive' do
    it 'passes when score is negative' do
      model.score = -1
      expect(model).to verify(:score).positive
    end

    it 'fails when score is zero or positive' do
      model.score = 0
      expect(model).not_to verify(:score).positive
    end
  end

  describe 'verify(:attribute).with_message' do
    it 'matches a specific error type' do
      expect(model).to verify(:name).with_message(:blank)
    end

    it 'fails when the error type does not match' do
      expect(model).not_to verify(:name).with_message(:inclusion)
    end
  end

  describe 'verify(:attribute) with no chain' do
    it 'passes when any error exists on the attribute' do
      expect(model).to verify(:name)
    end

    it 'fails when there are no errors on the attribute' do
      model.name = 'Alice'
      expect(model).not_to verify(:name)
    end
  end
end

RSpec.describe 'model_matchers shared context' do
  include_context :model_matchers

  let(:attrs) do
    { id: 1, name: 'Widget', type: 'widget' }
  end

  let(:model_obj) do
    double('Widget',
           attributes: { 'id' => 1, 'name' => 'Widget' },
           class:       double(name: 'Widget'),
           id:          1,
           name:        'Widget',
           type:        'widget').tap do |m|
      allow(m).to receive(:slice).with(:id, :name) { { 'id' => 1, 'name' => 'Widget' } }
      allow(m).to receive(:slice).with(:name)      { { 'name' => 'Widget' } }
    end
  end

  describe '#match_model_hash' do
    it 'passes when the hash matches the model attributes' do
      hash = { id: 1, name: 'Widget', type: 'widget' }
      expect(hash).to match_model_hash(model_obj)
    end

    it 'fails when the hash has a wrong value' do
      hash = { id: 99, name: 'Widget', type: 'widget' }
      expect(hash).not_to match_model_hash(model_obj)
    end

    it 'passes when restricted to specific attrs' do
      hash = { name: 'Widget' }
      expect(hash).to match_model_hash(model_obj, [:name])
    end
  end

  describe '#match_model' do
    it 'passes when the object has matching attributes' do
      expect(model_obj).to match_model(model_obj)
    end
  end

  describe 'array form' do
    it 'passes when each element matches' do
      expect([attrs]).to match_model_hash([model_obj])
    end

    it 'fails when one element does not match' do
      hash = { id: 2, name: 'Wrong', type: 'widget' }
      expect([hash]).not_to match_model_hash([model_obj])
    end
  end
end
