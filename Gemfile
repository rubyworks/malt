source 'https://rubygems.org'

gem 'blankslate'

group :build, :development do
  gem 'detroit'
end

group :test, :development do
  gem 'qed'
  gem 'rubytest'
  gem 'rubytest-cli'
  gem 'lemon'
  gem 'ae'
  gem 'rdoc', '>= 3'
  gem 'RedCloth'
  gem 'bluecloth'
  gem 'kramdown'
  gem 'rdiscount'
  gem 'haml'
  gem 'sass'
  gem 'less'
  gem 'tenjin'
  gem 'liquid'
  gem 'erubis'
  gem 'mustache'
  gem 'markaby'
  gem 'builder'
  gem 'radius'
  gem 'ragtag'
  gem 'redcarpet'
  gem 'wikicloth'
  gem 'maruku'
  gem 'creole'
  gem 'erector'
  gem 'coffee-script'
end

## JRuby can't compile libv8 which both less and coffee-script gems depend.
#if defined?(RUBY_ENGINE)
#  if RUBY_ENGINE == 'jruby'
#    @dependencies.reject!{ |d| d.name == 'less' or d.name == 'coffee-script' }
#  end
#end

