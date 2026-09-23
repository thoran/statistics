# Statistics/Correlation.rb
# Statistics::Correlation

# Pearson's product-moment correlation coefficient.

require_relative './Covariance'
require_relative './StandardDeviation'

module Statistics
  module Correlation
    module_function

    def of(xs, ys)
      denominator = StandardDeviation.of(xs) * StandardDeviation.of(ys)
      raise ArgumentError, 'Values of x and y must not be constant' if denominator == 0
      Covariance.of(xs, ys) / denominator
    end
  end
end
