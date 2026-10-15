# test/statistics-enumerable_test.rb

# The opt-in patches ::Enumerable, so each case runs in a subprocess, where it
# cannot leak into the rest of the suite. The mixin's own methods are tested by
# test/Statistics/Enumerable_test.rb.

require 'minitest/autorun'
require 'rbconfig'

require_relative '../lib/statistics'

describe 'statistics-enumerable' do
  def output_of(body)
    script = <<~RUBY
      require_relative '#{File.expand_path('../lib/statistics-enumerable', __dir__)}'
      require 'set'
      #{body}
    RUBY
    IO.popen([RbConfig.ruby, '-e', script], &:read)
  end

  it 'patches Enumerable so Array, Range and Set acquire the methods' do
    expected = [
      Statistics::Mean.of([1, 2, 3]),
      Statistics::Median.of([1, 2, 3]),
      Statistics::StandardDeviation.of([1, 2, 3]),
    ].join(' ')
    _(output_of("print [1, 2, 3].mean, ' ', (1..3).median, ' ', Set[1, 2, 3].standard_deviation")).must_equal expected
  end

  it 'is a complete line without require "statistics" above it' do
    _(output_of('print defined?(Statistics::Histogram)')).must_equal 'constant'
  end

  it 'leaves the methods usable on a Range, which has no empty?' do
    expected = Statistics::Histogram.new((1..10).to_a, bin_count: 5).bin_count.to_s
    _(output_of('print (1..10).histogram(bin_count: 5).bin_count')).must_equal expected
  end
end
