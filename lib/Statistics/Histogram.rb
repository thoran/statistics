# Statistics/Histogram.rb
# Statistics::Histogram

require_relative './Bin'

module Statistics
  class Histogram
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
        bin = Bin.bin_for_value(value, bins, bottom_boundary, @bin_width)
        bin.increment
      end
      bins
    end
  end
end
