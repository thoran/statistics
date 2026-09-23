# Statistics/Covariance.rb
# Statistics::Covariance

require_relative './Mean'

module Statistics
  module Covariance
    module_function

    def of(xs, ys, sample: false)
      raise ArgumentError, 'Values of x and y must be of equal size' unless xs.size == ys.size
      x_floats = xs.map(&:to_f)
      y_floats = ys.map(&:to_f)
      x_mean = Mean.of(x_floats)
      y_mean = Mean.of(y_floats)
      denominator = sample ? x_floats.size - 1 : x_floats.size
      x_floats.zip(y_floats).map{|x, y| (x - x_mean) * (y - y_mean)}.sum / denominator
    end
  end
end
