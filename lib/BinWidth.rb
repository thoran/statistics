# BinWidth.rb
# BinWidth

# 20260416
# 0.0.0

# Description: Calculates an appropriate bin width for histogramming continuous data.

# Changes:
# -/0:
# 1. + Initial version (square_root, freedman_diaconis, scott)

class BinWidth
  attr_reader :value

  def to_f
    @value
  end

  private

  def initialize(values, method: :square_root)
    raise ArgumentError, 'Values must not be empty' if values.empty?
    @values = values.map(&:to_f).sort
    @value = send(method)
  end

  def square_root
    range / Math.sqrt(@values.size)
  end

  def freedman_diaconis
    2.0 * iqr * @values.size ** (-1.0 / 3)
  end

  def scott
    3.49 * standard_deviation * @values.size ** (-1.0 / 3)
  end

  def range
    @values.last - @values.first
  end

  def iqr
    q75 - q25
  end

  def q25
    percentile(25)
  end

  def q75
    percentile(75)
  end

  def percentile(p)
    k = (p / 100.0) * (@values.size - 1)
    lower = @values[k.floor]
    upper = @values[k.ceil]
    lower + (upper - lower) * (k - k.floor)
  end

  def standard_deviation
    mean = @values.sum / @values.size
    variance = @values.map{|v| (v - mean) ** 2}.sum / (@values.size - 1)
    Math.sqrt(variance)
  end
end
