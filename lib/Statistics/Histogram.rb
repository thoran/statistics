# Statistics/Histogram.rb
# Statistics::Histogram

# 20260417
# 0.3.0

# Description: Bins an array of continuous numeric values into range-based frequency buckets. Bin width is calculated automatically using the square root method by default, or can be specified manually.

# Changes since 0.2:
# -/0:
# 1. + Bin.boundaries class method
# 2. ~ initialize: delegates to Bin.width and Bin.boundaries
# 3. ~ Bin: hash-based bins (no Bin instances), Bin is class-methods-only
# 4. - index_for_value (inlined back into allocate_values)
# 5. - determine_bin_width (replaced by Bin.width delegation)
# 6. - zero-range guard

module Statistics
  class Histogram
    class Bin
      def self.width(values, method: :square_root)
        send("#{method}_width", values)
      end

      def self.count(values, method: :square_root)
        send("#{method}_count", values)
      end

      def self.boundaries(values, bin_width: nil, method: :square_root)
        w = bin_width || width(values, method: method)
        sorted = values.map(&:to_f).sort
        result = []
        sorted.first.step(to: sorted.last + w, by: w){|b| result << b}
        result
      end

      private

      def self.square_root_width(values)
        range(values) * values.size ** (-1.0 / 2)
      end

      def self.square_root_count(values)
        Math.sqrt(values.size).ceil
      end

      def self.range(values)
        sorted = values.map(&:to_f).sort
        sorted.last - sorted.first
      end
    end

    attr_reader :bins

    def mode
      @bins.max_by{|_range, count| count}
    end

    def bin_count
      @bins.size
    end

    def to_s
      max_count = @bins.values.max
      @bins.map do |range, count|
        bar = '*' * ((count.to_f / max_count) * 40).round
        format('%8.2f...%-8.2f | %3d | %s', range.begin, range.end, count, bar)
      end.join("\n")
    end

    private

    def initialize(values, bin_width: nil, method: :square_root)
      raise ArgumentError, 'Values must not be empty' if values.empty?
      @values = values.map(&:to_f).sort
      @bin_width = bin_width || Bin.width(@values, method: method)
      @boundaries = Bin.boundaries(@values, bin_width: @bin_width, method: method)
      @bins = allocate_values
    end

    def allocate_values
      ranges = @boundaries.each_cons(2).map{|lower, upper| lower...upper}
      result = ranges.map{|r| [r, 0]}.to_h
      min = @boundaries.first
      @values.each do |v|
        i = ((v - min) / @bin_width).floor
        i = ranges.size - 1 if i >= ranges.size
        result[ranges[i]] += 1
      end
      result
    end
  end
end
