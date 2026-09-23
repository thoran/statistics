# test/Statistics/Variance_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/StandardDeviation'
require_relative '../../lib/Statistics/Variance'

describe Statistics::Variance do
  describe '.of' do
    it 'returns zero for identical values' do
      _(Statistics::Variance.of([5, 5, 5, 5])).must_equal 0.0
    end

    it 'calculates population variance by default' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      _(Statistics::Variance.of(values)).must_be_close_to 4.0
    end

    it 'calculates sample variance when requested' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      _(Statistics::Variance.of(values, sample: true)).must_be_close_to 32.0 / 7
    end

    it 'is the square of the standard deviation' do
      values = [2, 4, 4, 4, 5, 5, 7, 9]
      _(Statistics::Variance.of(values)).must_be_close_to Statistics::StandardDeviation.of(values) ** 2
    end
  end
end
