# statistics-enumerable.rb

# Opt in to the Enumerable sugar: every Array, Range, Set and
# Enumerable-including class acquires mean, median, variance,
# standard_deviation, percentile, q25, q75, iqr, covariance, correlation,
# linear_regression and histogram. Requires the core itself, so this line is
# complete on its own.

require_relative './statistics'

Enumerable.include(Statistics::Enumerable)
