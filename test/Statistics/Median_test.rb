# test/Statistics/Median_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Median'
require_relative '../../lib/Statistics/Percentile'

describe Statistics::Median do
  describe '.of' do
    it 'returns the middle value of an odd-length dataset' do
      _(Statistics::Median.of([1, 2, 3, 4, 5])).must_equal 3.0
    end

    it 'interpolates the midpoint of an even-length dataset' do
      _(Statistics::Median.of([1, 2, 3, 4])).must_equal 2.5
    end

    it 'is the 50th percentile' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      _(Statistics::Median.of(values)).must_equal Statistics::Percentile.of(values, 50)
    end

    it 'returns the value itself for a single value' do
      _(Statistics::Median.of([42])).must_equal 42.0
    end

    it 'returns the common value for identical values' do
      _(Statistics::Median.of([5, 5, 5, 5])).must_equal 5.0
    end

    it 'handles unsorted input' do
      _(Statistics::Median.of([5, 1, 4, 2, 3])).must_equal 3.0
    end
  end
end
