# test/Statistics/Enumerable_test.rb

# The mixin is tested by including it into a throwaway class, and not by
# requiring statistics-enumerable, since patching Enumerable here would leak
# into every other file in the run. The patch itself is tested, in a
# subprocess, by test/statistics-enumerable_test.rb.

require 'minitest/autorun'

require_relative '../../lib/Statistics/Enumerable'

describe Statistics::Enumerable do
  before do
    @values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @others = [2, 4, 5, 4, 5, 7, 8, 8, 10, 11]
    @sample = Class.new do
      include ::Enumerable
      include Statistics::Enumerable

      def initialize(values)
        @values = values
      end

      def each(&block)
        @values.each(&block)
      end
    end.new(@values)
  end

  it 'delegates mean to Statistics::Mean' do
    _(@sample.mean).must_equal Statistics::Mean.of(@values)
  end

  it 'delegates median to Statistics::Median' do
    _(@sample.median).must_equal Statistics::Median.of(@values)
  end

  it 'delegates variance to Statistics::Variance' do
    _(@sample.variance).must_equal Statistics::Variance.of(@values)
  end

  it 'forwards the sample keyword to variance' do
    _(@sample.variance(sample: true)).must_equal Statistics::Variance.of(@values, sample: true)
  end

  it 'delegates standard_deviation to Statistics::StandardDeviation' do
    _(@sample.standard_deviation).must_equal Statistics::StandardDeviation.of(@values)
  end

  it 'forwards the sample keyword to standard_deviation' do
    _(@sample.standard_deviation(sample: true)).must_equal Statistics::StandardDeviation.of(@values, sample: true)
  end

  it 'delegates percentile, q25, q75 and iqr' do
    _(@sample.percentile(75)).must_equal Statistics::Percentile.of(@values, 75)
    _(@sample.q25).must_equal Statistics::Percentile.q25(@values)
    _(@sample.q75).must_equal Statistics::Percentile.q75(@values)
    _(@sample.iqr).must_equal Statistics::IQR.of(@values)
  end

  it 'delegates covariance to Statistics::Covariance' do
    _(@sample.covariance(@others)).must_equal Statistics::Covariance.of(@values, @others)
  end

  it 'forwards the sample keyword to covariance' do
    _(@sample.covariance(@others, sample: true)).must_equal Statistics::Covariance.of(@values, @others, sample: true)
  end

  it 'delegates correlation to Statistics::Correlation' do
    _(@sample.correlation(@others)).must_equal Statistics::Correlation.of(@values, @others)
  end

  it 'delegates linear_regression to Statistics::LinearRegression' do
    regression = @sample.linear_regression(@others)
    _(regression).must_be_instance_of Statistics::LinearRegression
    _(regression.slope).must_equal Statistics::LinearRegression.new(@values, @others).slope
  end

  it 'delegates histogram to Statistics::Histogram' do
    _(@sample.histogram).must_be_instance_of Statistics::Histogram
  end

  it 'forwards histogram options' do
    _(@sample.histogram(bin_count: 5).bin_count).must_equal Statistics::Histogram.new(@values, bin_count: 5).bin_count
  end

  # The mixin lists its methods by hand, which is deliberate, since each line
  # adds a method to ::Enumerable and so wants a human to have typed it. This
  # case is the net under that: an operation module added to the library
  # without a line in the mixin fails here. Classes are left out, Bin being
  # internal and Histogram and LinearRegression not being of-shaped.
  it 'exposes every operation module the library has' do
    missing = operation_modules.reject do |operation|
      Statistics::Enumerable.method_defined?(method_name_for(operation))
    end
    _(missing).must_be_empty
  end

  def operation_modules
    Statistics.constants.map{|name| Statistics.const_get(name)}.select do |constant|
      constant.is_a?(Module) && !constant.is_a?(Class) && constant.respond_to?(:of)
    end
  end

  def method_name_for(operation)
    operation.name.split('::').last.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
  end
end
