# Statistics/Histogram.rb
# Statistics::Histogram

# 20260417
# 0.1.0

# Description: Will produce a histogram from an array of continuous numeric values, sorting them into range-based frequency buckets. Bin width is calculated automatically using the square root method by default, or can be specified manually. Each Bin instance tracks the count of values that fell into its interval.

# Changes since 0.0:
# -/0:
# 1. + Statistics::Histogram::Bin
# 2. ~ allocate_values: creates Bin instances instead of hash entries

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
        data_range(values) * values.size ** (-1.0 / 2)
      end

      def self.square_root_count(values)
        Math.sqrt(values.size).ceil
      end

      attr_reader :range, :values

      def <<(value)
        @values << value
      end

      def count
        @values.size
      end

      def width
        @range.end - @range.begin
      end

      def empty?
        @values.empty?
      end

      private

      def initialize(range)
        @range = range
        @values = []
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
        format('%8.2f...%-8.2f | %3d | %s', bin.range.begin, bin.range.end, bin.count, bar)
      end.join("\n")
    end

    private

    def initialize(values, bin_width: nil, bin_count: nil, method: :square_root)
      raise ArgumentError, 'Values must not be empty' if values.empty?
      @values = values.map(&:to_f).sort
      @bin_width = bin_width || bin_count && (Bin.data_range(@values) / bin_count.to_f) || Bin.width(@values, method: method)
      @boundaries = compute_boundaries
      @bins = allocate_values
    end

    def compute_boundaries
      @values.first.step(to: @values.last + @bin_width, by: @bin_width).to_a
    end

    def allocate_values
      bins = @boundaries.each_cons(2).map{|lower, upper| Bin.new(lower...upper)}
      min = @boundaries.first
      @values.each do |v|
        i = ((v - min) / @bin_width).floor
        i = bins.size - 1 if i >= bins.size
        bins[i] << v
      end
      bins
    end
  end
end
