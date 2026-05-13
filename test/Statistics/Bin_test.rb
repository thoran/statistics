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
