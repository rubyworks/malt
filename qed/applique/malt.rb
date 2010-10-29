require 'malt'
require 'ae/pry'

When "say we have a (((\\w+))) document called '(((\\S+)))' containing" do |type, fname, text|
  file = File.join('tmp',fname)
  File.open(file, 'w'){ |f| f << text }
end

When "verify that (((.*?))) is" do |var, text|
  out = instance_variable_get(var)
  out.strip.assert == text.strip
end

