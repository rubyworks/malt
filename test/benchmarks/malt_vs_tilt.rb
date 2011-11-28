require 'benchmark'
require 'malt'
require 'tilt'

dir = File.dirname(__FILE__)

file = dir + '/../fixtures/sample.erb'
rdoc = dir + '/../fixtures/sample.rdoc'

data = {
  :page_title => "Demonstration of ERb", 
  :salutation => "Dear programmer," 
}

count = 1000

puts "#{count} Times"
puts
puts "Tilt"

Benchmark.bmbm do |bm|
  bm.report("Tilt ERB") { count.times{ Tilt.new(file).render(nil, data) } }
  bm.report("Tilt RDoc") { count.times{ Tilt.new(rdoc).render(nil, data) } }
end

puts
puts "Malt"

Benchmark.bmbm do |bm|
  bm.report("Malt ERB") { count.times{ Malt.render(:file=>file, :locals=>data) } }
  bm.report("Malt RDoc") { count.times{ Malt.render(:file=>rdoc, :locals=>data) } }
end

