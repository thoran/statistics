# Statistics/Histogram.rb
# Statistics::Histogram

# 20260417
# 0.2.0

# Description: Will produce a histogram from an array of continuous numeric values, sorting them into range-based frequency buckets. Bin width is calculated automatically using the square root method by default, or can be specified manually. Each Bin instance tracks the count of values that fell into its interval.

# Changes since 0.1:
# -/0:
# 1. ~ Bin: count-tracking via increment instead of values-storing via
# 2. ~ Bin: attr_reader :interval instead of :range
# 3. + Bin#empty? checks @count == 0 instead of @values.empty?
# 4. + determine_bin_width: zero-range guard
# 5. + index_for_value extracted from allocate_values

module Statistics
  class Histogram
    class Bin
      def self.width(values, method: :square_root)
        send("#{method}_width", values)
      end

      def self.count(values, method: :square_root)
        send("#{method}_count", values)
      end

      def self.data_range(values)
        values.last - values.first
      end

      def self.square_root_width(values)
        data_range(values) / Math.sqrt(values.size)
      end

      def self.square_root_count(values)
        Math.sqrt(values.size).ceil
      end

      attr_reader :interval

      def increment
        @count += 1
      end

      def count
        @count
      end

      def width
        @interval.end - @interval.begin
      end

      def empty?
        @count == 0
      end

      private

      def initialize(interval)
        @interval = interval
        @count = 0
      end
    end

    attr_reader :bins, :boundaries

    def mode
      @bins.max_by(&:count)
    end

    def bin_count
      @bins.size
    end

    def to_s
      max_count = @bins.map(&:count).max
      @bins.map do |bin|
        bar = '*' * ((bin.count.to_f / max_count) * 40).round
        format('%8.2f...%-8.2f | %3d | %s', bin.interval.begin, bin.interval.end, bin.count, bar)
      end.join("\n")
    end

    private

    def initialize(values, bin_width: nil, bin_count: nil, method: :square_root)
      raise ArgumentError, 'Values must not be empty' if values.empty?
      @values = values.map(&:to_f).sort
      @bin_width = determine_bin_width(bin_width, bin_count, method)
      @boundaries = calculate_boundaries
      @bins = allocate_values
    end

    def determine_bin_width(bin_width, bin_count, method)
      if bin_width
        bin_width
      elsif bin_count
        Bin.data_range(@values) / bin_count.to_f
      elsif Bin.data_range(@values) == 0
        1.0
      else
        Bin.width(@values, method: method)
      end
    end

    def calculate_boundaries
      @values.first.step(to: @values.last + @bin_width, by: @bin_width).to_a
    end

    def allocate_values
      bins = @boundaries.each_cons(2).map{|lower, upper| Bin.new(lower...upper)}
      bottom_boundary = @boundaries.first
      @values.each do |value|
        i = index_for_value(value, bins.size, bottom_boundary)
        bins[i].increment
      end
      bins
    end

    def index_for_value(value, bin_count, bottom_boundary)
      i = ((value - bottom_boundary) / @bin_width).floor
      i >= bin_count ? bin_count - 1 : i
    end
  end
end
