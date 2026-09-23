# test/Statistics/Correlation_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Correlation'

describe Statistics::Correlation do
  describe '.of' do
    it 'returns one for a perfect positive relationship' do
      _(Statistics::Correlation.of([1, 2, 3, 4, 5], [2, 4, 6, 8, 10])).must_be_close_to 1.0
    end

    it 'returns minus one for a perfect negative relationship' do
      _(Statistics::Correlation.of([1, 2, 3, 4, 5], [10, 8, 6, 4, 2])).must_be_close_to(-1.0)
    end

    it 'lies between minus one and one' do
      correlation = Statistics::Correlation.of([1, 2, 3, 4, 5], [2, 4, 5, 4, 5])
      _(correlation).must_be :>, -1.0
      _(correlation).must_be :<, 1.0
    end

    it 'is unaffected by a change of scale' do
      xs = [1, 2, 3, 4, 5]
      ys = [2, 4, 5, 4, 5]
      scaled = Statistics::Correlation.of(xs.map{|x| x * 100}, ys)
      _(scaled).must_be_close_to Statistics::Correlation.of(xs, ys)
    end

    it 'raises when a set of values is constant' do
      _(proc{Statistics::Correlation.of([1, 2, 3], [7, 7, 7])}).must_raise ArgumentError
    end
  end
end
