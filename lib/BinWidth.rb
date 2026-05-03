# BinWidth.rb
# BinWidth

# 20260416
# 0.1.0

# Description: Calculates an appropriate bin width for histogramming continuous data.

# Changes:
# -/0:
# 1. + tuneable_root as the general form
# 2. ~ square_root rewritten as range * n^(-1/2) form

class BinWidth

  attr_reader :value

  def to_f
    @value
  end

  private

  def initialize(values, method: :square_root, factor: 2.0)
    raise ArgumentError, 'Values must not be empty' if values.empty?
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

  def range
    @values.last - @values.first
  end
end
