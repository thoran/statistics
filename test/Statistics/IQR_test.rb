# test/Statistics/IQR_test.rb

require 'minitest/autorun'

require_relative '../../lib/Statistics/IQR'

describe Statistics::IQR do
  describe '.of' do
    it 'returns the difference between q75 and q25' do
      values = [1, 2, 3, 4, 5]
      expected = Statistics::Percentile.q75(values) - Statistics::Percentile.q25(values)
      _(Statistics::IQR.of(values)).must_equal expected
    end

    it 'returns zero for identical values' do
      _(Statistics::IQR.of([5, 5, 5, 5])).must_equal 0.0
    end

    it 'handles a two-value dataset' do
      values = [10, 20]
      _(Statistics::IQR.of(values)).must_be_close_to 5.0
    end

    it 'handles unsorted input' do
      sorted = [1, 2, 3, 4, 5, 6, 7, 8]
      shuffled = [5, 1, 8, 3, 7, 2, 6, 4]
      _(Statistics::IQR.of(shuffled)).must_equal Statistics::IQR.of(sorted)
    end
  end
end
