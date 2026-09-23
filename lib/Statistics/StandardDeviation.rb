# Statistics/StandardDeviation.rb
# Statistics::StandardDeviation

require_relative './Variance'

module Statistics
  module StandardDeviation
    module_function

    def of(values, sample: false)
      Math.sqrt(Variance.of(values, sample: sample))
    end
  end
end
