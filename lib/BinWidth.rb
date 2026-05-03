# BinWidth.rb
# BinWidth

# 20260416
# 0.2.0

# Description: Calculates an appropriate bin width for histogramming continuous data.

# Changes:
# -/0: Reintroduce all named strategies.

class BinWidth
  METHODS = [:square_root, :cube_root, :freedman_diaconis, :scott, :tuneable_root].freeze
  DEFAULT_METHOD = :square_root
  DEFAULT_FACTOR = 2.0

  attr_reader :value

  def to_f
    @value
  end

  private

  def initialize(values, method: DEFAULT_METHOD, factor: DEFAULT_FACTOR)
    raise ArgumentError, 'Values must not be empty' if values.empty?
    raise ArgumentError, "Unknown method: #{method}" unless METHODS.include?(method)
    raise ArgumentError, 'Factor must be positive' unless factor > 0
    @values = values.map(&:to_f).sort
    @factor = factor
    @value = send(method)
  end

  def tuneable_root
    range * @values.size ** (-1.0 / @factor)
  end

  def square_root
    range * @values.size ** (-1.0 / 2)
  end

  def cube_root
    range * @values.size ** (-1.0 / 3)
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
