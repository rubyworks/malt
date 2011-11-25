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
  @params ||= {}
  @params[:file] = fname

  file = File.join(fname)
  File.open(file, 'w'){ |f| f << text }
end

When "verify that (((@\w+))) is" do |iv, text|
  out = instance_variable_get(iv)
  out.strip.assert == text.strip
end

When 'verify that the result is' do |text|
  @_.strip.assert == text.strip
end

When 'the result (((will|should))) be' do |_, text|
  @_.to_s.strip.assert == text.strip
end

When "render the `(((\S+)))` document as `(((\w+)))` via `Malt.render`." do |file, into, text|
  @_ = Malt.render(:to=>into, file=>file)
end

When 'the following (((@\w+)))' do |name, text|
  instance_variable_set(name, text)
end

