# frozen_string_literal: true

# Shared context: error_matcher
# Provides a +verify+ matcher for asserting ActiveModel validation errors.
#
# Usage:
#   include_context :error_matcher
#   it { is_expected.to verify(:name).present }
RSpec.shared_context :error_matcher do
  matcher :verify do |attribute|
    match do |actual|
      @actual    = actual
      @attribute = attribute
      actual.validate
      if @message
        errors.include?(@message)
      else
        errors.any?
      end
    end

    def errors
      @errors ||= @actual.errors.errors
                         .select { |err| err.attribute == @attribute }
                         .map(&:type)
    end

    description do
      desc = if @message
               "have error :#{@message} on :#{@attribute}"
             else
               "have any error on :#{@attribute}"
             end

      if errors.present?
        desc << " (errors: #{errors.join(', ')})"
      else
        desc << '. No errors were found.'
      end

      desc
    end

    chain :positive do
      @message = :greater_than_or_equal_to
    end

    chain :numeric do
      @message = :not_a_number
    end

    chain :present do
      @message = :blank
    end

    chain :absent do
      @message = :absent
    end

    chain :with_message do |message|
      @message = message
    end
  end
end

# Shared context: model_matchers
# Provides helpers for comparing ActiveRecord model instances against response hashes.
#
# Usage:
#   include_context :model_matchers
#   it { expect(json_response).to match_model_hash(user) }
RSpec.shared_context :model_matchers do
  class ModelMatcherResult
    DIFFER = RSpec::Support::Differ.new(color: true) unless defined?(DIFFER)

    attr_reader :expected, :actual, :matches, :index

    def initialize(expected, actual, matcher, index = nil)
      @expected = expected
      @actual   = actual
      @matches  = matcher.call(**expected).matches?(actual)
      @index    = index
    end

    def match?    = matches
    def failed?   = !matches

    def diff
      DIFFER.diff(actual, expected).strip
    end

    def to_s
      if index.nil?
        "Expected result to match: #{diff}"
      else
        "Expected result #{index} to match:#{diff}"
      end
    end
  end

  matcher :model_matcher do |matcher, model, attrs, extra, extra_block = nil|
    match do |actual|
      matcher_method = matcher.is_a?(Symbol) ? method(matcher) : matcher

      if model.is_a?(Array)
        @results = model.length.times.map do |i|
          a = actual[i]
          ModelMatcherResult.new(
            expected_attributes(model[i], attrs, extra, extra_block, a),
            a,
            matcher_method,
            i
          )
        end
        @results.all?(&:match?)
      else
        @result = ModelMatcherResult.new(
          expected_attributes(model, attrs, extra, extra_block, actual),
          actual,
          matcher_method
        )
        @result.match?
      end
    end

    failure_message do |_actual|
      if @results
        @results.select(&:failed?).join("\n")
      else
        @result.to_s
      end
    end
  end

  # @param attrs [Array<Symbol>, nil] limit comparison to these attributes (all if nil)
  def expected_attributes(model, attrs, extra, extra_block, actual)
    include_type = attrs.blank? || attrs.delete(:type)

    expected = (attrs.blank? ? model.attributes : model.slice(*attrs)).deep_symbolize_keys
    expected.merge!(extra) if extra
    expected.merge!(extra_block.call(model)) if extra_block
    expected[:type] ||= model.class.name.underscore if include_type

    if actual.is_a?(Hash)
      expected.transform_values! do |v|
        v.respond_to?(:iso8601) ? v.as_json : v
      end
    end

    expected
  end

  def match_model(model, attrs = nil, **extra, &extra_block)
    model_matcher(:have_attributes, model, attrs, extra, extra_block)
  end

  def match_model_hash(model, attrs = nil, **extra, &extra_block)
    model_matcher(:match, model, attrs, extra, extra_block)
  end

  def include_model_hash(model, attrs = nil, **extra, &extra_block)
    model_matcher(:include, model, attrs, extra, extra_block)
  end

  alias match_models        match_model
  alias match_models_hashes match_model_hash
  alias include_model_hashes include_model_hash
end
