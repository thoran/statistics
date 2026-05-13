# CHANGELOG

## [0.6.1] - 20260513
## Statistics::Histogram::Bin --> Statistics::Bin

1. lib/Statistics/Histogram/Bin.rb --> lib/Statistics/Bin.rb
2. test/Statistics/Histogram/Bin\_test.rb --> test/Statistics/Bin\_test.rb
3. ~ lib/Statistics/Histogram.rb: /require\_relative './Histogram/Bin'/require\_relative './Bin'/
4. ~ lib/statistics.rb: + require\_relative './Statistics/Bin'
5. ~ .gitignore: Add standard contents.
6. ~ README.md: + Contributions section
7. ~ lib/Statistics/VERSION.rb: /0.6.0/0.6.1/

## [0.6.0] - 20260504
## + Percentile, StandardDeviation, IQR

1. + lib/Statistics/Percentile.rb
2. + lib/Statistics/StandardDeviation.rb
3. + lib/Statistics/IQR.rb
4. + test/Statistics/Percentile\_test.rb
5. + test/Statistics/StandardDeviation\_test.rb
6. + test/Statistics/IQR\_test.rb
7. - Gemfile: As there are no dependencies it isn't doing anything!
8. ~ statistics.rb.gemspec: dependencies=() also therefore not used.
9. /CHANGELOG/CHANGELOG.md/


## [0.5.0] - 20260503
## + Bin.bin\_for\_value, Bin split, gem scaffolding.

1. + Bin.bin\_for\_value (wraps index\_for\_value, now private)
2. ~ Histogram#allocate\_values: Use Bin.bin\_for\_value
3. ~ Bin split out to lib/Statistics/Histogram/Bin.rb
4. + lib/statistics.rb
5. + lib/Statistics/VERSION.rb
6. + statistics.rb.gemspec
7. + Gemfile
8. + Rakefile
9. + README.md
10. + LICENSE
11. + test/Statistics/Histogram\_test.rb
12. + test/Statistics/Histogram/Bin\_test.rb


## [0.4.0] - 20260502
## + Bin instances; consolidated class methods.

1. + Bin instances (count-tracking via increment, attr\_reader :interval)
2. ~ Bin.width: handles bin\_width, bin\_count, zero-range, and method selection
3. + Bin.boundaries (from 0.3.0)
4. + Bin.index\_for\_value (was Histogram#index\_for\_value)
5. + Bin.data\_range
6. ~ class << self for class methods with private boundary
7. ~ attr\_reader :count replaces hand-written method


## [0.3.0] - 20260417
## Hash-based bins; Bin as class-methods-only.

1. + Bin.boundaries class method
2. ~ initialize: delegates to Bin.width and Bin.boundaries
3. ~ Bin: hash-based bins (no Bin instances), Bin is class-methods-only
4. - index\_for\_value (inlined back into allocate\_values)
5. - determine\_bin\_width (replaced by Bin.width delegation)
6. - zero-range guard


## [0.2.0] - 20260417
## Swap storing values per bin for counting per bin; interval; zero-range guard.

1. ~ Bin: count-tracking via increment instead of storing values in array
2. ~ Bin: attr\_reader :interval instead of :range
3. + Bin#empty? checks @count == 0 instead of @values.empty?
4. + determine\_bin\_width: zero-range guard
5. + index\_for\_value extracted from allocate\_values


## [0.1.1] - 20260417
## + Statistics::Histogram#determine\_bin\_width

1. ~ initialize: extracted determine\_bin\_width from one-liner
2. /compute\_boundaries/calculate\_boundaries/


## [0.1.0] - 20260417
## + Statistics::Histogram::Bin

1. + Statistics::Histogram::Bin
2. ~ allocate\_values: creates Bin instances instead of hash entries


## [0.0.0] - 20260417
## + Statistics::Histogram

1. + lib/Statistics/Histogram.rb
2. - lib/BinWidth.rb


## [pre-0.0.0] - 20260416
## ~ BinWidth: Reintroduce binning strategies; extra guard clauses.

1. Reintroduce all named strategies.
2. /0.1.0/0.2.0/


## [pre-0.0.0] - 20260416
## + BinWidth#tuneable_root

1. + tuneable\_root as the general form
2. ~ square\_root rewritten as range * n^(-1/2) form
3. /0.0.0/0.1.0/


## [pre-0.0.0] - 20260416
## + BinWidth

1. + lib/BinWidth.rb
