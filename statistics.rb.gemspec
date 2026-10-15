require_relative './lib/Statistics/VERSION'

class Gem::Specification
  def development_dependencies=(gems)
    gems.each{|gem| add_development_dependency(*gem)}
  end
end

Gem::Specification.new do |spec|
  spec.name = 'statistics.rb'
  spec.version = Statistics::VERSION

  spec.summary = "A statistics library for Ruby."
  spec.description = "A composable statistics library for Ruby. Histogram, Percentile, Mean, Median, Variance, StandardDeviation, IQR, Covariance, Correlation, LinearRegression, and an opt-in Enumerable mixin."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/statistics'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3'
  spec.require_paths = ['lib']

  spec.files = [
    'statistics.rb.gemspec',
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    'CHANGELOG',
    'LICENSE',
    'Rakefile',
    'README.md',
  ].flatten

  spec.development_dependencies = %w{
    rake
    minitest
  }
end
