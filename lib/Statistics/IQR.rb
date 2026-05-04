# Statistics/IQR.rb
# Statistics::IQR

require_relative './Percentile'

module Statistics
  module IQR
    module_function

    def of(values)
      Percentile.q75(values) - Percentile.q25(values)
    end
  end
end
