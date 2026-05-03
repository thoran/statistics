# Statistics/Histogram.rb
# Statistics::Histogram

# 20260502
# 0.4.0

# Description: Will produce a histogram from an array of continuous numeric values, sorting them into range-based frequency buckets. Bin width is calculated automatically using the square root method by default, or can be specified manually. Each Bin instance tracks the count of values that fell into its interval.

# Changes since 0.3:
# -/0:
# 1. + Bin instances (count-tracking via increment, attr_reader :interval)
# 2. ~ Bin.width: handles bin_width, bin_count, zero-range, and method selection
# 3. + Bin.boundaries (from 0.3.0)
# 4. + Bin.index_for_value (was Histogram#index_for_value)
# 5. + Bin.data_range
# 6. ~ class << self for class methods with private boundary
# 7. ~ attr_reader :count replaces hand-written method

module Statistics
  class Histogram
    class Bin
      class << self
        def width(values, bin_width: nil, bin_count: nil, method: :square_root)
          if bin_width
            bin_width
          elsif bin_count
            data_range(values) / bin_count.to_f
          elsif data_range(values) == 0
            1.0
          else
            send("#{method}_width", values)
          end
        end

        def count(values, method: :square_root)
          send("#{method}_count", values)
        end

        def data_range(values)
          values.last - values.first
        end

        def boundaries(values, bin_width: nil, bin_count: nil, method: :square_root)
          w = bin_width || width(values, bin_count: bin_count, method: method)
          values.first.step(to: values.last + w, by: w).to_a
        end

        def index_for_value(value, bin_count, bottom_boundary, bin_width)
          i = ((value - bottom_boundary) / bin_width).floor
          i >= bin_count ? bin_count - 1 : i
        end

        private

        def square_root_width(values)
          data_range(values) * values.size ** (-1.0 / 2)
        end

        def square_root_count(values)
          Math.sqrt(values.size).ceil
        end
      end # class << self

      attr_reader :count, :interval

      def increment
        @count += 1
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
      @bin_width = Bin.width(@values, bin_width: bin_width, bin_count: bin_count, method: method)
      @boundaries = Bin.boundaries(@values, bin_width: @bin_width)
      @bins = allocate_values
    end

    def allocate_values
      bins = @boundaries.each_cons(2).map{|lower, upper| Bin.new(lower...upper)}
      bottom_boundary = @boundaries.first
      @values.each do |value|
        i = Bin.index_for_value(value, bins.size, bottom_boundary, @bin_width)
        bins[i].increment
      end
      bins
    end
  end
end
