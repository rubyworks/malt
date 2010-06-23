Given "an equivalent template for each engine" do
  require 'malt'
  require 'ostruct'

  @templates = {}
  @templates[:erb]    = File.dirname(__FILE__) + "/../samples/sample.erb"
  @templates[:erubis] = File.dirname(__FILE__) + "/../samples/sample.erb"

  #template_types = %w{.erb .erubis} # .liquid .radius} #.mustache
  #@templates = {}
  #template_types.each do |ext|
  #  @templates[ext] = File.dirname(__FILE__) + "/../samples/sample#{ext}"
  #end
end

And /a (.*?) for a data source/ do |source_type|
  case source_type
  when 'Binding'
    name  = "Tom"
    state = "Maryland"
    @source = binding
  when 'Object'
    @source = SampleObject.new("Tom","Maryland")
  when 'Struct'
    @source = Struct.new(:name, :state).new("Tom", "Maryland")
  when 'OpenStruct'
    @source = OpenStruct.new(:name=>"Tom", :state=>"Maryland")
  when 'Hash'
    @source = {:name=>"Tom", :state=>"Maryland"}
  end
end

When "the template is rendered" do
  @results = {}
  @templates.each do |engine, file|
    puts "    #{engine}"
    file = Malt.file(file, :engine=>engine) #Tilt[ext].new(file)
    @results[engine] = file.html(@source).to_s
  end
end

Then "the result is the same for each" do
  @results.each do |ea, a|
    @results.each do |eb, b|
      raise "#{ea} != #{eb}\n#{a} != #{b}" unless a == b
    end
  end
end

