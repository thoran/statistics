# Statistics/Histogram.rb
# Statistics::Histogram

# 20260417
# 0.0.0

# Description: Will produce a histogram from an array of continuous numeric values, sorting them into range-based frequency buckets. Bin width is calculated automatically using the square root method by default, or can be specified manually.

# Changes:
# -/0:
# 1. + Statistics::Histogram

module Statistics
  class Histogram
    attr_reader :bins, :boundaries

    def mode
      @bins.max_by{|_interval, count| count}
    end

    def bin_count
      @bins.size
    end

    def to_s
      max_count = @bins.values.max
      @bins.map do |interval, count|
        bar = '*' * ((count.to_f / max_count) * 40).round
        format('%8.2f...%-8.2f | %3d | %s', interval.begin, interval.end, count, bar)
      end.join("\n")
    end

    private

    def initialize(values, bin_width: nil, bin_count: nil)
      raise ArgumentError, 'Values must not be empty' if values.empty?
      @values = values.map(&:to_f).sort
      @bin_width = determine_bin_width(bin_width, bin_count)
      @boundaries = calculate_boundaries
      @bins = allocate_values
    end

    def determine_bin_width(bin_width, bin_count)
      if bin_width
        bin_width
      elsif bin_count
        data_range / bin_count.to_f
      elsif data_range == 0
        1.0
      else
        data_range / Math.sqrt(@values.size)
      end
    end

    def data_range
      @values.last - @values.first
    end

    def calculate_boundaries
      @values.first.step(to: @values.last + @bin_width, by: @bin_width).to_a
    end

    def allocate_values
      intervals = @boundaries.each_cons(2).map{|lower, upper| lower...upper}
      result = intervals.map{|interval| [interval, 0]}.to_h
      bottom_boundary = @boundaries.first
      @values.each do |value|
        i = index_for_value(value, intervals.size, bottom_boundary)
        result[intervals[i]] += 1
      end
      result
    end

    def index_for_value(value, bin_count, bottom_boundary)
      i = ((value - bottom_boundary) / @bin_width).floor
      i >= bin_count ? bin_count - 1 : i
    end
  end
end
