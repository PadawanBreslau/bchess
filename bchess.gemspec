lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bchess/version'

Gem::Specification.new do |spec|
  spec.name          = 'bchess'
  spec.version       = Bchess::VERSION
  spec.authors       = ['Staszek Zawadzki']
  spec.email         = ['s.zawadzki@visuality.pl']

  spec.summary       = 'Parsing chess PGN games.'
  spec.description   = 'Parsing and validating a chess games and returning as chess game objects'
  spec.homepage      = 'https://github.com/visualitypl/bchess'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'treetop', '~> 1.6', '>= 1.6.11'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'treetop', '~> 1.6'
end
