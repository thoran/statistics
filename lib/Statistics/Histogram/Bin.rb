# Statistics/Histogram/Bin.rb
# Statistics::Histogram::Bin

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

        def bin_for_value(value, bins, bottom_boundary, bin_width)
          index = index_for_value(value, bins.count, bottom_boundary, bin_width)
          bins[index]
        end

        private

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
end
