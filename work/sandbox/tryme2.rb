require 'malt'

file = Malt.file('test.rdoc.erb') #, :recompile=>true)
html = file.html(:title=>"THE TITLE", :word=>"WORD")

p html.class
p html.file

puts
puts html

