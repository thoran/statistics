# test/Statistics/Covariance_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Covariance'
require_relative '../../lib/Statistics/Variance'

describe Statistics::Covariance do
  describe '.of' do
    it 'calculates population covariance by default' do
      _(Statistics::Covariance.of([1, 2, 3, 4, 5], [2, 4, 6, 8, 10])).must_be_close_to 4.0
    end

    it 'calculates sample covariance when requested' do
      covariance = Statistics::Covariance.of([1, 2, 3, 4, 5], [2, 4, 6, 8, 10], sample: true)
      _(covariance).must_be_close_to 5.0
    end

    it 'is negative for inversely related values' do
      _(Statistics::Covariance.of([1, 2, 3, 4, 5], [10, 8, 6, 4, 2])).must_be_close_to(-4.0)
    end

    it 'returns zero when one set of values is constant' do
      _(Statistics::Covariance.of([1, 2, 3], [7, 7, 7])).must_equal 0.0
    end

    it 'is symmetric' do
      xs = [1, 2, 3, 4, 5]
      ys = [2, 4, 5, 4, 5]
      _(Statistics::Covariance.of(xs, ys)).must_equal Statistics::Covariance.of(ys, xs)
    end

    it 'is the variance when both sets of values are the same' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      _(Statistics::Covariance.of(values, values)).must_be_close_to Statistics::Variance.of(values)
    end

    it 'raises when the sets of values differ in size' do
      _(proc{Statistics::Covariance.of([1, 2, 3], [1, 2])}).must_raise ArgumentError
    end
  end
end
