# test/Statistics/Histogram_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Histogram'

describe Statistics::Histogram do
  describe 'with default bin width' do
    before do
      @values = (1..25).to_a
      @histogram = Statistics::Histogram.new(@values)
    end

    it 'creates bins' do
      _(@histogram.bins).wont_be_empty
    end

    it 'allocates all values' do
      total = @histogram.bins.map(&:count).sum
      _(total).must_equal @values.size
    end

    it 'uses square root rule for bin count' do
      _((@histogram.bin_count - Math.sqrt(@values.size).ceil).abs).must_be :<=, 1
    end
  end

  describe 'with explicit bin_width' do
    before do
      @values = (1..10).to_a
      @histogram = Statistics::Histogram.new(@values, bin_width: 5.0)
    end

    it 'creates bins of the specified width' do
      _(@histogram.bins.first.width.round(10)).must_equal 5.0
    end

    it 'allocates all values' do
      total = @histogram.bins.map(&:count).sum
      _(total).must_equal @values.size
    end
  end

  describe 'with explicit bin_count' do
    before do
      @values = (1..10).to_a
      @histogram = Statistics::Histogram.new(@values, bin_count: 3)
    end

    it 'creates approximately the requested number of bins' do
      _((@histogram.bin_count - 3).abs).must_be :<=, 1
    end

    it 'allocates all values' do
      total = @histogram.bins.map(&:count).sum
      _(total).must_equal @values.size
    end
  end

  describe '#mode' do
    it 'returns the bin with the highest count' do
      values = [1, 1, 1, 1, 5, 5, 10]
      histogram = Statistics::Histogram.new(values, bin_width: 3.0)
      mode_bin = histogram.mode
      _(mode_bin.interval.cover?(1)).must_equal true
    end
  end

  describe '#bin_count' do
    it 'returns the number of bins' do
      values = [1, 2, 3, 4, 5]
      histogram = Statistics::Histogram.new(values, bin_count: 2)
      _(histogram.bin_count).must_be :>=, 1
    end
  end

  describe '#boundaries' do
    before do
      @values = [5, 10, 15, 20]
      @histogram = Statistics::Histogram.new(@values, bin_width: 5.0)
    end

    it 'starts at the minimum value' do
      _(@histogram.boundaries.first).must_equal 5.0
    end

    it 'extends past the maximum value' do
      _(@histogram.boundaries.last).must_be :>=, 20.0
    end

    it 'has one more boundary than bins' do
      _(@histogram.boundaries.size).must_equal @histogram.bin_count + 1
    end
  end

  describe '#to_s' do
    before do
      @values = [1, 2, 3, 4, 5]
      @histogram = Statistics::Histogram.new(@values, bin_count: 2)
    end

    it 'returns a string' do
      _(@histogram.to_s).must_be_kind_of String
    end

    it 'contains bar characters' do
      _(@histogram.to_s).must_include '*'
    end
  end

  describe 'with identical values' do
    before do
      @values = [5, 5, 5, 5, 5]
      @histogram = Statistics::Histogram.new(@values)
    end

    it 'does not raise' do
      _(@histogram.bins).wont_be_empty
    end

    it 'puts all values in one bin' do
      _(@histogram.bins.map(&:count).sum).must_equal 5
    end
  end

  describe 'with empty values' do
    it 'raises ArgumentError' do
      _{Statistics::Histogram.new([])}.must_raise ArgumentError
    end
  end

  describe 'with a single value' do
    it 'creates a histogram with one bin' do
      histogram = Statistics::Histogram.new([42])
      _(histogram.bins.map(&:count).sum).must_equal 1
    end
  end

  describe 'with float values' do
    it 'handles floats correctly' do
      values = [1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9]
      histogram = Statistics::Histogram.new(values, bin_width: 3.0)
      total = histogram.bins.map(&:count).sum
      _(total).must_equal values.size
    end
  end
end
