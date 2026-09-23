# test/Statistics/LinearRegression_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/LinearRegression'

describe Statistics::LinearRegression do
  describe '#slope' do
    it 'returns the least squares slope' do
      _(Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).slope).must_be_close_to 0.6
    end

    it 'returns the exact slope for collinear points' do
      _(Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 6, 8, 10]).slope).must_be_close_to 2.0
    end

    it 'is negative for inversely related values' do
      _(Statistics::LinearRegression.new([1, 2, 3], [6, 4, 2]).slope).must_be_close_to(-2.0)
    end

    it 'is zero when the values of y are constant' do
      _(Statistics::LinearRegression.new([1, 2, 3], [5, 5, 5]).slope).must_equal 0.0
    end
  end

  describe '#intercept' do
    it 'returns the least squares intercept' do
      _(Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).intercept).must_be_close_to 2.2
    end

    it 'returns the common value when the values of y are constant' do
      _(Statistics::LinearRegression.new([1, 2, 3], [5, 5, 5]).intercept).must_be_close_to 5.0
    end
  end

  describe '#predict' do
    it 'extrapolates beyond the fitted values' do
      _(Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).predict(6)).must_be_close_to 5.8
    end

    it 'reproduces collinear points exactly' do
      _(Statistics::LinearRegression.new([1, 2, 3], [2, 4, 6]).predict(2)).must_be_close_to 4.0
    end
  end

  describe '#residuals' do
    it 'returns the difference between each value of y and its prediction' do
      residuals = Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).residuals
      _(residuals.size).must_equal 5
      _(residuals.sum).must_be_close_to 0.0
    end

    it 'returns zeroes for collinear points' do
      residuals = Statistics::LinearRegression.new([1, 2, 3], [2, 4, 6]).residuals
      residuals.each{|residual| _(residual).must_be_close_to 0.0}
    end
  end

  describe '#r_squared' do
    it 'returns one for a perfect fit' do
      _(Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 6, 8, 10]).r_squared).must_be_close_to 1.0
    end

    it 'returns the proportion of variance explained' do
      _(Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).r_squared).must_be_close_to 0.6
    end

    it 'returns one when the values of y are constant' do
      _(Statistics::LinearRegression.new([1, 2, 3], [5, 5, 5]).r_squared).must_equal 1.0
    end
  end

  describe '#standard_error' do
    it 'returns the standard error of the residuals' do
      standard_error = Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).standard_error
      _(standard_error).must_be_close_to Math.sqrt(0.8)
    end

    it 'returns nil when there are too few points' do
      _(Statistics::LinearRegression.new([1, 2], [3, 4]).standard_error).must_be_nil
    end
  end

  describe '#to_s' do
    it 'renders the fitted line' do
      line = Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5]).to_s
      _(line).must_equal 'y = 0.6000x + 2.2000 (r² = 0.6000)'
    end

    it 'renders a negative intercept as a subtraction' do
      line = Statistics::LinearRegression.new([1, 2, 3], [0, 2, 4]).to_s
      _(line).must_equal 'y = 2.0000x - 2.0000 (r² = 1.0000)'
    end
  end

  describe '.new' do
    it 'raises when the sets of values differ in size' do
      _(proc{Statistics::LinearRegression.new([1, 2, 3], [1, 2])}).must_raise ArgumentError
    end

    it 'raises when there are fewer than two points' do
      _(proc{Statistics::LinearRegression.new([1], [1])}).must_raise ArgumentError
    end

    it 'raises when the values of x are all identical' do
      _(proc{Statistics::LinearRegression.new([2, 2, 2], [1, 2, 3])}).must_raise ArgumentError
    end

    it 'accepts unsorted input' do
      sorted = Statistics::LinearRegression.new([1, 2, 3, 4, 5], [2, 4, 5, 4, 5])
      shuffled = Statistics::LinearRegression.new([3, 1, 5, 2, 4], [5, 2, 5, 4, 4])
      _(shuffled.slope).must_be_close_to sorted.slope
      _(shuffled.intercept).must_be_close_to sorted.intercept
    end
  end
end
