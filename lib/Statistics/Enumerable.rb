# Statistics/Enumerable.rb
# Statistics::Enumerable

# Mixin form of the library. Including it into Enumerable (which is what
# require 'statistics-enumerable' does) gives every Array, Range, Set and
# Enumerable-including class the operations as methods. Including it into a
# single class of one's own is the way to have the methods without the patch.
#
# Each method delegates to the module-function, with self as the values, so
# that values.mean and Statistics::Mean.of(values) are the same call.

require_relative './Correlation'
require_relative './Covariance'
require_relative './Histogram'
require_relative './IQR'
require_relative './LinearRegression'
require_relative './Mean'
require_relative './Median'
require_relative './Percentile'
require_relative './StandardDeviation'
require_relative './Variance'

module Statistics
  module Enumerable
    def mean
      Mean.of(self)
    end

    def median
      Median.of(self)
    end

    def variance(sample: false)
      Variance.of(self, sample: sample)
    end

    def standard_deviation(sample: false)
      StandardDeviation.of(self, sample: sample)
    end

    def percentile(p)
      Percentile.of(self, p)
    end

    def q25
      Percentile.q25(self)
    end

    def q75
      Percentile.q75(self)
    end

    def iqr
      IQR.of(self)
    end

    def covariance(others, sample: false)
      Covariance.of(self, others, sample: sample)
    end

    def correlation(others)
      Correlation.of(self, others)
    end

    def linear_regression(others)
      LinearRegression.new(self, others)
    end

    def histogram(**options)
      Histogram.new(self, **options)
    end
  end
end
