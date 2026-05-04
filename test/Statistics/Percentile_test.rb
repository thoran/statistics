# test/Statistics/Percentile_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Percentile'

describe Statistics::Percentile do
  describe '.of' do
    it 'returns the minimum for the 0th percentile' do
      values = [1, 2, 3, 4, 5]
      _(Statistics::Percentile.of(values, 0)).must_equal 1.0
    end

    it 'returns the maximum for the 100th percentile' do
      values = [1, 2, 3, 4, 5]
      _(Statistics::Percentile.of(values, 100)).must_equal 5.0
    end

    it 'returns the median for the 50th percentile' do
      values = [1, 2, 3, 4, 5]
      _(Statistics::Percentile.of(values, 50)).must_equal 3.0
    end

    it 'interpolates between values' do
      values = [10, 20, 30, 40]
      _(Statistics::Percentile.of(values, 25)).must_equal 17.5
    end

    it 'handles a single value' do
      _(Statistics::Percentile.of([42], 50)).must_equal 42.0
    end

    it 'handles unsorted input' do
      values = [5, 1, 3, 2, 4]
      _(Statistics::Percentile.of(values, 50)).must_equal 3.0
    end
  end

  describe '.q25' do
    it 'returns the 25th percentile' do
      values = [1, 2, 3, 4, 5]
      _(Statistics::Percentile.q25(values)).must_equal Statistics::Percentile.of(values, 25)
    end
  end

  describe '.q75' do
    it 'returns the 75th percentile' do
      values = [1, 2, 3, 4, 5]
      _(Statistics::Percentile.q75(values)).must_equal Statistics::Percentile.of(values, 75)
    end
  end
end
