# test/Statistics/Mean_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Mean'

describe Statistics::Mean do
  describe '.of' do
    it 'returns the arithmetic mean' do
      _(Statistics::Mean.of([1, 2, 3, 4, 5])).must_equal 3.0
    end

    it 'returns a float for integer input' do
      _(Statistics::Mean.of([1, 2])).must_equal 1.5
    end

    it 'returns the value itself for a single value' do
      _(Statistics::Mean.of([42])).must_equal 42.0
    end

    it 'returns the common value for identical values' do
      _(Statistics::Mean.of([5, 5, 5, 5])).must_equal 5.0
    end
  end
end
