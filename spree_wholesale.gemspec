Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_wholesale'
  s.version     = '4.0'
  s.authors     = ['Michael Davidson']
  s.email       = ['michael@boldb.com.au']
  s.homepage    = 'https://github.com/mdavo6/spree_wholesale'
  s.summary     = 'Adds wholesale account to Spree Commerce.'
  s.description = 'Spree Wholesale adds a wholesale_price field to variants and allows users with a "wholesaler" role to access these prices.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 4.0'
  s.add_dependency 'spree_frontend', '~> 4.0'
  s.add_dependency 'spree_backend', '~> 4.0'
  s.add_dependency 'spree_auth_devise', '~> 4.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'coffee-rails'
end
