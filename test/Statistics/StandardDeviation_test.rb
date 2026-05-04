# test/Statistics/StandardDeviation_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/StandardDeviation'

describe Statistics::StandardDeviation do
  describe '.of' do
    it 'returns zero for identical values' do
      _(Statistics::StandardDeviation.of([5, 5, 5, 5])).must_equal 0.0
    end

    it 'calculates population standard deviation by default' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      _(Statistics::StandardDeviation.of(values)).must_be_close_to 2.0
    end

    it 'calculates sample standard deviation when requested' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      sample_sd = Statistics::StandardDeviation.of(values, sample: true)
      population_sd = Statistics::StandardDeviation.of(values)
      _(sample_sd).must_be :>, population_sd
    end

    it 'handles a single value' do
      _(Statistics::StandardDeviation.of([42])).must_equal 0.0
    end

    it 'handles two values' do
      values = [0, 10]
      _(Statistics::StandardDeviation.of(values)).must_be_close_to 5.0
    end
  end
end
