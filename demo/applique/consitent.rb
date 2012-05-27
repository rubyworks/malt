When "an equivalent template for each engine" do
  require 'malt'
  require 'ostruct'

  @templates = {}
  @templates[:erb]      = File.dirname(__FILE__) + "/../samples/consistent/sample.erb"
  @templates[:erubis]   = File.dirname(__FILE__) + "/../samples/consistent/sample.erb"
  @templates[:liquid]   = File.dirname(__FILE__) + "/../samples/consistent/sample.liquid"
  #@templates[:mustache] = File.dirname(__FILE__) + "/../samples/consistent/sample.mustache"
  @templates[:radius]   = File.dirname(__FILE__) + "/../samples/consistent/sample.radius"
  @templates[:tenjin]   = File.dirname(__FILE__) + "/../samples/consistent/sample.rbhtml"
  @templates[:string]   = File.dirname(__FILE__) + "/../samples/consistent/sample.str"

  #template_types = %w{.erb .erubis} # .liquid .radius} #.mustache
  #@templates = {}
  #template_types.each do |ext|
  #  @templates[ext] = File.dirname(__FILE__) + "/../samples/sample#{ext}"
  #end
end

When "an equivalent template for each html engine" do
  require 'malt'
  require 'ostruct'
  require 'nokogiri'

  @template_mode = :html

  @templates = {}
  @templates[:haml]     = File.dirname(__FILE__) + "/../samples/consistent/sample.haml"
  @templates[:ragtag]   = File.dirname(__FILE__) + "/../samples/consistent/sample.ragtag"
  @templates[:builder]  = File.dirname(__FILE__) + "/../samples/consistent/sample.builder"
  @templates[:erector]  = File.dirname(__FILE__) + "/../samples/consistent/sample.erector"
  @templates[:markaby]  = File.dirname(__FILE__) + "/../samples/consistent/sample.markaby"
  @templates[:nokogiri] = File.dirname(__FILE__) + "/../samples/consistent/sample.nokogiri"
end

When /a (.*?) for a data source/ do |source_type|
  @source = lambda do
    case source_type
    when 'Binding'
      name  = "Tom"
      state = "Maryland"
      binding
    when 'Object'
      SampleObject.new("Tom","Maryland")
    when 'Struct'
      Struct.new(:name, :state).new("Tom", "Maryland")
    when 'OpenStruct'
      OpenStruct.new(:name=>"Tom", :state=>"Maryland")
    when 'Hash'
      {:name=>"Tom", :state=>"Maryland"}
    end
  end
end

When "the equivalent template is rendered" do
  @results = {}
  @templates.each do |engine, file|
    file = Malt.file(file, :engine=>engine) #Tilt[ext].new(file)
    @results[engine] = file.render(@source.call){ 'yielded' }.to_s
  end
end

When "the result is the same for each" do
  case @template_mode
  when :html
    @results.each do |ea, a|
      @results.each do |eb, b|
# $stdout.puts "    #{ea} == #{eb}"
        a = a.gsub("\n",'').gsub(/\s\s+/,'')
        b = b.gsub("\n",'').gsub(/\s\s+/,'')
        na = Nokogiri.XML("<root>#{a}</root>").to_xml(:indent=>2)
        nb = Nokogiri.XML("<root>#{b}</root>").to_xml(:indent=>2)
        na.assert == nb
      end
    end
  else
    @results.each do |ea, a|
      @results.each do |eb, b|
        a.assert == b
      end
    end
  end
end

