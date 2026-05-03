require_relative './lib/Statistics/VERSION'

class Gem::Specification
  def dependencies=(gems)
    gems.each{|gem| add_dependency(*gem)}
  end

  def development_dependencies=(gems)
    gems.each{|gem| add_development_dependency(*gem)}
  end
end

Gem::Specification.new do |spec|
  spec.name = 'statistics.rb'

  spec.version = Statistics::VERSION
  spec.date = '2026-05-03'

  spec.summary = "A statistics library for Ruby."
  spec.description = "A composable statistics library for Ruby. Histogram with automatic bin width calculation and composable Bin class."

  spec.author = 'thoran'
  spec.email = 'code@thoran.com'
  spec.homepage = 'http://github.com/thoran/statistics'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 2.7'

  spec.files = [
    Dir['lib/**/*.rb'],
    Dir['test/**/*.rb'],
    'CHANGELOG',
    'Gemfile',
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
