source :rubygems
gemspec

# JRuby can't compile libv8 which both less and coffee-script gems depend.
if RUBY_ENGINE == 'jruby'
  @dependencies.reject{ |d| d.name == 'less' or d.name == 'coffee-script' }
end

