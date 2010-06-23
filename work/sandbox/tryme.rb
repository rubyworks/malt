require 'malt'

puts
puts "---- erb ----"
puts
puts Malt.file('test.erb').html(:five=>"Hello")
puts

puts "---- haml ----"
puts
puts Malt.file('test.haml').html(:date=>Time.now,:name=>"Hello")
puts

puts "---- rdoc ----"
puts
puts Malt.file('test.rdoc').html
puts

puts "---- rdiscount ----"
puts
puts Malt.file('test.md').html
puts

puts "---- rdoc.erb ----"
puts
puts Malt.file('test.rdoc.erb').html(:title=>"Hello", :word=>"Yes!")
puts


puts "---- rdoc.erb ----"
puts
puts Malt.file('test.rdoc').markdown
puts

