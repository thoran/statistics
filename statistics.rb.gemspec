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
  spec.description = "A composable statistics library for Ruby. Histogram, Percentile, StandardDeviation, IQR."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/statistics'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.7'

  spec.files = [
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    'CHANGELOG.md',
    'LICENSE',
    'Rakefile',
    'README.md',
    'statistics.rb.gemspec',
  ].flatten

  spec.require_paths = ['lib']

  spec.development_dependencies = %w{
    rake
    minitest
  }
end
