# Statistics/StandardDeviation.rb
# Statistics::StandardDeviation

module Statistics
  module StandardDeviation
    module_function

    def of(values, sample: false)
      floats = values.map(&:to_f)
      mean = floats.sum / floats.size
      denominator = sample ? floats.size - 1 : floats.size
      variance = floats.map{|v| (v - mean) ** 2}.sum / denominator
      Math.sqrt(variance)
    end
  end
end
