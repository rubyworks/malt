require 'benchmark'
require 'malt'
require 'tilt'

file = File.dirname(__FILE__) + '/sample.erb'

data = {
  :page_title => "Demonstration of ERb", 
  :salutation => "Dear programmer," 
}

count = 1000

puts "#{count} Times"
puts

Benchmark.bmbm do |bm|
  bm.report("Tilt") { count.times{ Tilt.new(file).render(nil, data) } }
  bm.report("Malt") { count.times{ Malt.render(:file=>file, :data=>data) } }
end

