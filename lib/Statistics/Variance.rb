# Statistics/Variance.rb
# Statistics::Variance

require_relative './Mean'

module Statistics
  module Variance
    module_function

    def of(values, sample: false)
      floats = values.map(&:to_f)
      mean = Mean.of(floats)
      denominator = sample ? floats.size - 1 : floats.size
      floats.map{|v| (v - mean) ** 2}.sum / denominator
    end
  end
end
