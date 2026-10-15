# Statistics/Median.rb
# Statistics::Median

# The median is the 50th percentile under Hyndman and Fan method 7, which
# Percentile.of already implements, so this delegates rather than re-sorting.

require_relative './Percentile'

module Statistics
  module Median
    module_function

    def of(values)
      Percentile.of(values, 50)
    end
  end
end
