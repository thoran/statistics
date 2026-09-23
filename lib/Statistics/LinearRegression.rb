# Statistics/LinearRegression.rb
# Statistics::LinearRegression

# An ordinary least squares fit of y = slope * x + intercept.

require_relative './Covariance'
require_relative './Mean'
require_relative './Variance'

module Statistics
  class LinearRegression
    attr_reader :slope, :intercept

    def predict(x)
      @intercept + @slope * x
    end

    def residuals
      @xs.zip(@ys).map{|x, y| y - predict(x)}
    end

    def r_squared
      return 1.0 if total_sum_of_squares == 0
      1.0 - residual_sum_of_squares / total_sum_of_squares
    end

    def standard_error
      Math.sqrt(residual_sum_of_squares / (@xs.size - 2)) if @xs.size > 2
    end

    def to_s
      sign = @intercept < 0 ? '-' : '+'
      format('y = %.4fx %s %.4f (r² = %.4f)', @slope, sign, @intercept.abs, r_squared)
    end

    private

    def initialize(xs, ys)
      @xs = xs.map(&:to_f)
      @ys = ys.map(&:to_f)
      validate!
      @slope = Covariance.of(@xs, @ys) / Variance.of(@xs)
      @intercept = Mean.of(@ys) - @slope * Mean.of(@xs)
    end

    def validate!
      raise ArgumentError, 'Values of x and y must be of equal size' unless @xs.size == @ys.size
      raise ArgumentError, 'At least two points are required' if @xs.size < 2
      raise ArgumentError, 'Values of x must not all be identical' if @xs.uniq.size == 1
    end

    def residual_sum_of_squares
      @residual_sum_of_squares ||= residuals.map{|residual| residual ** 2}.sum
    end

    def total_sum_of_squares
      @total_sum_of_squares ||= (
        mean = Mean.of(@ys)
        @ys.map{|y| (y - mean) ** 2}.sum
      )
    end
  end
end
