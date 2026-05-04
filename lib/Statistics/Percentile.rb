# Statistics/Percentile.rb
# Statistics::Percentile

# These methods employ linear interpolation. See Hyndman and Fan method 7.

module Statistics
  module Percentile
    module_function

    def of(values, p)
      sorted = values.map(&:to_f).sort
      k = (p / 100.0) * (sorted.size - 1)
      lower = sorted[k.floor]
      upper = sorted[k.ceil]
      lower + (upper - lower) * (k - k.floor)
    end

    def q25(values)
      of(values, 25)
    end

    def q75(values)
      of(values, 75)
    end
  end
end
