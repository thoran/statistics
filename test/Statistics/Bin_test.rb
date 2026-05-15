# test/Statistics/Bin_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/Bin'

describe Statistics::Bin do
  describe '.width' do
    it 'calculates square root width by default' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values)
      expected = (values.last - values.first) * values.size ** (-1.0 / 2)
      _(width).must_be_close_to expected
    end

    it 'returns explicit bin_width when provided' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, bin_width: 7.5)
      _(width).must_equal 7.5
    end

    it 'calculates width from bin_count when provided' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, bin_count: 10)
      _(width).must_be_close_to 9.9
    end

    it 'returns 1.0 for zero-range data' do
      values = [5.0, 5.0, 5.0]
      width = Statistics::Bin.width(values)
      _(width).must_equal 1.0
    end

    it 'calculates cube root width' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, method: :cube_root)
      expected = (values.last - values.first) * values.size ** (-1.0 / 3)
      _(width).must_be_close_to expected
    end

    it 'calculates tuneable root width with custom factor' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, method: :tuneable_root, factor: 4.0)
      expected = (values.last - values.first) * values.size ** (-1.0 / 4)
      _(width).must_be_close_to expected
    end

    it 'tuneable root with default factor matches square root width' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, method: :tuneable_root)
      expected = Statistics::Bin.width(values, method: :square_root)
      _(width).must_be_close_to expected
    end

    it 'calculates Freedman-Diaconis width' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, method: :freedman_diaconis)
      expected = 2.0 * Statistics::IQR.of(values) * values.size ** (-1.0 / 3)
      _(width).must_be_close_to expected
    end

    it 'calculates Scott width' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, method: :scott)
      expected = 3.49 * Statistics::StandardDeviation.of(values) * values.size ** (-1.0 / 3)
      _(width).must_be_close_to expected
    end

    it 'calculates Sturges width' do
      values = (1..100).to_a.map(&:to_f)
      width = Statistics::Bin.width(values, method: :sturges)
      expected_count = Math.log2(values.size).ceil + 1
      expected = (values.last - values.first) / expected_count
      _(width).must_be_close_to expected
    end

    it 'raises for empty values' do
      _{Statistics::Bin.width([])}.must_raise ArgumentError
    end

    it 'raises for unknown method' do
      _{Statistics::Bin.width([1.0, 2.0], method: :bogus)}.must_raise ArgumentError
    end

    it 'raises for non-positive factor' do
      _{Statistics::Bin.width([1.0, 2.0], factor: 0)}.must_raise ArgumentError
    end
  end

  describe '.count' do
    it 'calculates square root count by default' do
      values = (1..100).to_a.map(&:to_f)
      _(Statistics::Bin.count(values)).must_equal Math.sqrt(values.size).ceil
    end

    it 'calculates cube root count' do
      values = (1..100).to_a.map(&:to_f)
      _(Statistics::Bin.count(values, method: :cube_root)).must_equal (values.size ** (1.0 / 3)).ceil
    end

    it 'calculates tuneable root count with custom factor' do
      values = (1..100).to_a.map(&:to_f)
      _(Statistics::Bin.count(values, method: :tuneable_root, factor: 4.0)).must_equal (values.size ** (1.0 / 4)).ceil
    end

    it 'calculates Freedman-Diaconis count' do
      values = (1..100).to_a.map(&:to_f)
      expected_width = 2.0 * Statistics::IQR.of(values) * values.size ** (-1.0 / 3)
      expected = ((values.last - values.first) / expected_width).ceil
      _(Statistics::Bin.count(values, method: :freedman_diaconis)).must_equal expected
    end

    it 'calculates Scott count' do
      values = (1..100).to_a.map(&:to_f)
      expected_width = 3.49 * Statistics::StandardDeviation.of(values) * values.size ** (-1.0 / 3)
      expected = ((values.last - values.first) / expected_width).ceil
      _(Statistics::Bin.count(values, method: :scott)).must_equal expected
    end

    it 'calculates Sturges count' do
      values = (1..100).to_a.map(&:to_f)
      _(Statistics::Bin.count(values, method: :sturges)).must_equal Math.log2(values.size).ceil + 1
    end
  end

  describe '.boundaries' do
    it 'returns an array starting at the minimum value' do
      values = (1..10).to_a.map(&:to_f)
      boundaries = Statistics::Bin.boundaries(values, bin_width: 3.0)
      _(boundaries.first).must_equal 1.0
    end

    it 'extends past the maximum value' do
      values = (1..10).to_a.map(&:to_f)
      boundaries = Statistics::Bin.boundaries(values, bin_width: 3.0)
      _(boundaries.last).must_be :>=, 10.0
    end
  end

  describe '.bin_for_value' do
    it 'returns the correct bin' do
      bins = [5.0, 10.0, 15.0, 20.0].each_cons(2).map do |lower, upper|
        Statistics::Bin.new(lower...upper)
      end
      bin = Statistics::Bin.bin_for_value(7.0, bins, 5.0, 5.0)
      _(bin.interval).must_equal(5.0...10.0)
    end

    it 'clamps to the last bin for values at the upper boundary' do
      bins = [5.0, 10.0, 15.0].each_cons(2).map do |lower, upper|
        Statistics::Bin.new(lower...upper)
      end
      bin = Statistics::Bin.bin_for_value(15.0, bins, 5.0, 5.0)
      _(bin.interval).must_equal(10.0...15.0)
    end
  end

  describe 'instance methods' do
    before do
      @bin = Statistics::Bin.new(1.0...5.0)
    end

    it 'starts with count of zero' do
      _(@bin.count).must_equal 0
    end

    it 'increments count' do
      @bin.increment
      @bin.increment
      _(@bin.count).must_equal 2
    end

    it 'reports width' do
      _(@bin.width).must_equal 4.0
    end

    it 'is empty when count is zero' do
      _(@bin.empty?).must_equal true
    end

    it 'is not empty after increment' do
      @bin.increment
      _(@bin.empty?).must_equal false
    end
  end
end
