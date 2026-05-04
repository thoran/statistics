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

### Histogram

Create a histogram from an array of numeric values:

```ruby
require 'statistics.rb'

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
require 'statistics.rb'

values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

Statistics::Percentile.of(values, 75)   # => 7.75
Statistics::Percentile.q25(values)      # => 3.25
Statistics::Percentile.q75(values)      # => 7.75
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

## Roadmap

- Optional per-bin value storage
- Additional bin width methods (Freedman-Diaconis, Scott, Sturges, cube root, tuneable root)
- Aligned/neat bin boundaries

## License

MIT
