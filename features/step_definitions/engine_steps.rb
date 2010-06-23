Given "an equivalent template for each engine" do
  require 'malt'
  require 'ostruct'
  template_types = %w{.erb .erubis .liquid .radius} #.mustache
  @templates = {}
  template_types.each do |ext|
    @templates[ext] = File.dirname(__FILE__) + "/../samples/sample#{ext}"
  end
end

And /a (.*?) for scope/ do |scope_type|
  case scope_type
  when 'Binding'
    name  = "Tom"
    state = "Maryland"
    @scope = binding
  when 'Object'
    @scope = SampleObject.new("Tom","Maryland")
  when 'Struct'
    @scope = Struct.new(:name, :state).new("Tom", "Maryland")
  #when 'OpenStruct'
  #  @scope = OpenStruct.new
  #  @scope.name  = "Tom"
  #  @scope.state = "Maryland"
  when 'Hash'
    @scope = {:name=>"Tom", :state=>"Maryland"}
  end
end

And /^(only\ |)a (.*?) for locals/ do |only, locals_type|
  case locals_type
  when 'Hash'
    @locals = {}
    @locals[:name]  = "Tom" if only
    @locals[:state] = 'Florida'
  when 'OpenStruct'
    @locals = OpenStruct.new
    @locals.name  = "Tom" if only
    @locals.state = "Florida"
  end
end

When "the template is rendered" do
  @results = {}
  @templates.each do |ext, file|
    puts "    " + ext
    engine = Tilt[ext].new(file)
    @results[ext] = engine.render(@scope, @locals).to_s
  end
end

Then "the result is the same for each" do
  @results.each do |exta, a|
    @results.each do |extb, b|
      raise "#{exta} != #{extb}\n#{a} != #{b}" unless a == b
    end
  end
end

