# statistics.rb

A statistics library for Ruby.

## Installation

```
gem install statistics.rb
```

Or add to your Gemfile:

```ruby
gem 'statistics.rb'
```

## Usage

### Two surfaces

Every operation is a module-function taking the values as its first argument. An
opt-in file grafts the same operations onto `Enumerable` as methods:

```ruby
require 'statistics'             # the library: Statistics::Mean.of(values), nothing patched
require 'statistics-enumerable'  # opt in: Enumerable acquires mean, median, variance,
                                 # standard_deviation, percentile, q25, q75, iqr,
                                 # covariance, correlation, linear_regression, histogram
```

The second requires the first itself, so it is a complete line and wants no
`require 'statistics'` above it. Every `Array`, `Range`, `Set` and
`Enumerable`-including class then has the methods:

```ruby
values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

values.mean                               # => 5.5
values.median                             # => 5.5
(1..10).percentile(75)                    # => 7.75
values.standard_deviation(sample: true)   # => 3.0276503540974917
values.histogram(bin_count: 5)            # => #<Statistics::Histogram ...>
[1, 2, 3, 4, 5].correlation([2, 4, 5, 4, 5])  # => 0.7745966692414833
```

Each method delegates to the module-function with `self` as the values, so
`values.mean` and `Statistics::Mean.of(values)` are the same call.

The patch wants Ruby 3.0 or later, since that is where `include` into a module
began propagating to the classes which already include it. The mixin itself,
included directly into a class, has no such requirement.

A program which would rather not patch core includes the mixin into a class of
its own, which is all `statistics-enumerable` does, less the patch:

```ruby
require 'statistics'

class Series
  include Enumerable
  include Statistics::Enumerable

  def each(&block)
    @values.each(&block)
  end
end
```

### Histogram

Create a histogram from an array of numeric values:

```ruby
require 'statistics'

values = [1.2, 3.4, 5.6, 7.8, 2.3, 4.5, 6.7, 8.9, 3.2, 5.4]

h = Statistics::Histogram.new(values)
puts h
```

Output:

```
    1.20...3.63  |   3 | ****************************************
    3.63...6.07  |   3 | ****************************************
    6.07...8.50  |   2 | ***************************
    8.50...10.93 |   1 | *************
```

#### Automatic bin width

By default, bin width is calculated using the square root rule: `data_range / sqrt(n)`.

Other strategies are available via the `method:` option:

```ruby
h = Statistics::Histogram.new(values, method: :square_root)       # default
h = Statistics::Histogram.new(values, method: :cube_root)
h = Statistics::Histogram.new(values, method: :freedman_diaconis)
h = Statistics::Histogram.new(values, method: :scott)
h = Statistics::Histogram.new(values, method: :sturges)
```

The `tuneable_root` method takes a `factor` (default `2.0`, equivalent to `square_root`):

```ruby
h = Statistics::Histogram.new(values, method: :tuneable_root, factor: 4.0)
Statistics::Bin.width(values, method: :tuneable_root, factor: 4.0)
```

#### Manual bin width

```ruby
h = Statistics::Histogram.new(values, bin_width: 2.0)
```

#### Manual bin count

```ruby
h = Statistics::Histogram.new(values, bin_count: 5)
```

#### Querying the histogram

```ruby
h.bins          # => [#<Bin ...>, #<Bin ...>, ...]
h.boundaries    # => [1.2, 3.77, 6.34, ...]
h.bin_count     # => 4
h.mode          # => #<Bin interval=1.2...3.77 count=3>

h.bins.first.interval  # => 1.2...3.77
h.bins.first.count     # => 3
h.bins.first.width     # => 2.57
h.bins.first.empty?    # => false
```

### Percentile

These methods employ linear interpolation. See Hyndman and Fan method 7.

```ruby
require 'statistics'

values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

Statistics::Percentile.of(values, 75)   # => 7.75
Statistics::Percentile.q25(values)      # => 3.25
Statistics::Percentile.q75(values)      # => 7.75
```

### Mean

```ruby
Statistics::Mean.of(values)  # => 5.5
```

### Median

The 50th percentile, by the same linear interpolation:

```ruby
Statistics::Median.of(values)        # => 5.5
Statistics::Median.of([1, 2, 3, 4])  # => 2.5
```

### Variance

```ruby
Statistics::Variance.of(values)                # => population (default)
Statistics::Variance.of(values, sample: true)  # => sample (Bessel's correction)
```

### Standard Deviation

```ruby
Statistics::StandardDeviation.of(values)                # => population (default)
Statistics::StandardDeviation.of(values, sample: true)  # => sample (Bessel's correction)
```

### Interquartile Range

```ruby
Statistics::IQR.of(values)  # => 4.5
```

### Covariance

```ruby
xs = [1, 2, 3, 4, 5]
ys = [2, 4, 5, 4, 5]

Statistics::Covariance.of(xs, ys)                # => 1.2, population (default)
Statistics::Covariance.of(xs, ys, sample: true)  # => 1.5, sample (Bessel's correction)
```

### Correlation

Pearson's product-moment correlation coefficient:

```ruby
Statistics::Correlation.of(xs, ys)  # => 0.7745966692414833
```

### Linear Regression

An ordinary least squares fit of `y = slope * x + intercept`:

```ruby
lr = Statistics::LinearRegression.new(xs, ys)

lr.slope           # => 0.6
lr.intercept       # => 2.2
lr.predict(6)      # => 5.8
lr.r_squared       # => 0.6, modulo floating point error
lr.residuals       # => [-0.8, 0.6, 1.0, -0.6, -0.2], modulo floating point error
lr.standard_error  # => 0.8944271909999159, nil for fewer than three points
puts lr            # => y = 0.6000x + 2.2000 (r² = 0.6000)
```

`.new` raises an `ArgumentError` when the two sets of values differ in size, when there
are fewer than two points, or when the values of x are all identical, which leaves the
slope undefined.

## Roadmap

- Optional per-bin value storage
- Aligned/neat bin boundaries

## Contributing

1. Fork it [https://github.com/thoran/statistics/fork](https://github.com/thoran/statistics/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request

## License

MIT
