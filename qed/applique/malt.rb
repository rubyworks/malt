require 'malt'
require 'ae/pry'

def sample(file)
  s = File.join(File.dirname(__FILE__), '..', '..', 'qed', 'samples', file)
  File.expand_path(s)
end

#unless File.directory?('samples')
#  dir = File.dirname(__FILE__)+'/../samples'
#  FileUtils.cp_r(dir,'.')
#end

When "say we have a((n?)) (((\\w+))) document called '(((\\S+)))' containing" do |type, fname, text|
  file = File.join(fname)
  File.open(file, 'w'){ |f| f << text }
end

When "verify that (((.*?))) is" do |var, text|
  out = instance_variable_get(var)
  out.strip.assert == text.strip
end

