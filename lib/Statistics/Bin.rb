# Statistics/Bin.rb
# Statistics::Bin

require_relative './IQR'
require_relative './StandardDeviation'

module Statistics
  class Bin
    METHODS = [:square_root, :cube_root, :freedman_diaconis, :scott, :sturges, :tuneable_root].freeze
    DEFAULT_METHOD = :square_root
    DEFAULT_FACTOR = 2.0

    class << self
      def width(values, bin_width: nil, bin_count: nil, method: :square_root, factor: nil)
        validate!(values, method: method, factor: factor)
        if bin_width
          bin_width
        elsif bin_count
          data_range(values) / bin_count.to_f
        elsif data_range(values) == 0
          1.0
        elsif method == :tuneable_root
          tuneable_root_width(values, factor || DEFAULT_FACTOR)
        else
          send("#{method}_width", values)
        end
      end

      def count(values, method: :square_root, factor: nil)
        validate!(values, method: method, factor: factor)
        if method == :tuneable_root
          tuneable_root_count(values, factor || DEFAULT_FACTOR)
        else
          send("#{method}_count", values)
        end
      end

      def boundaries(values, bin_width: nil, bin_count: nil, method: :square_root, factor: nil)
        validate!(values, method: method, factor: factor)
        w = bin_width || width(values, bin_count: bin_count, method: method, factor: factor)
        values.first.step(to: values.last + w, by: w).to_a
      end

      def bin_for_value(value, bins, bottom_boundary, bin_width)
        index = index_for_value(value, bins.count, bottom_boundary, bin_width)
        bins[index]
      end

      private

      def data_range(values)
        values.last - values.first
      end

      def index_for_value(value, bin_count, bottom_boundary, bin_width)
        i = ((value - bottom_boundary) / bin_width).floor
        i >= bin_count ? bin_count - 1 : i
      end

      def square_root_width(values)
        data_range(values) * values.size ** (-1.0 / 2)
      end

      def square_root_count(values)
        Math.sqrt(values.size).ceil
      end

      def cube_root_width(values)
        data_range(values) * values.size ** (-1.0 / 3)
      end

      def cube_root_count(values)
        (values.size ** (1.0 / 3)).ceil
      end

      def tuneable_root_width(values, factor)
        data_range(values) * values.size ** (-1.0 / factor)
      end

      def tuneable_root_count(values, factor)
        (values.size ** (1.0 / factor)).ceil
      end

      def freedman_diaconis_width(values)
        2.0 * IQR.of(values) * values.size ** (-1.0 / 3)
      end

      def freedman_diaconis_count(values)
        (data_range(values) / freedman_diaconis_width(values)).ceil
      end

      def scott_width(values)
        3.49 * StandardDeviation.of(values) * values.size ** (-1.0 / 3)
      end

      def scott_count(values)
        (data_range(values) / scott_width(values)).ceil
      end

      def sturges_width(values)
        data_range(values) / sturges_count(values)
      end

      def sturges_count(values)
        Math.log2(values.size).ceil + 1
      end

      def validate!(values, method:, factor: nil)
        raise ArgumentError, 'Values must not be empty' if values.empty?
        raise ArgumentError, "Unknown method: #{method}" unless METHODS.include?(method)
        raise ArgumentError, 'Factor must be positive' if factor && factor <= 0
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
end
