require 'malt/kernel'
require 'malt/render'

module Malt

  class << self
    include Malt::Kernel
  end

  #
  def self.register(malt_class, *exts)
    exts.each do |ext|
      type = ext_to_type(ext)
      registry[type] = malt_class
    end
  end

  #
  def self.registry
    @registry ||= {}
  end


  #
  def self.file(file, options={})
    type = options[:type] || options[:format] || File.extname(file)
    type = ext_to_type(type)
    malt_class = registry[type]
    raise "unkown type -- #{type}" unless malt_class
    malt_class.new(options.merge(:file=>file,:type=>type))
  end

  #
  def self.text(text, options={})
    if file = options[:file]
      ext = File.extname(file)
      ext = nil if ext.empty?
    end
    type = options[:type] || options[:format] || ext
    type = ext_to_type(type)
    malt_class = registry[type] || Format::Text
    #raise "unkown type -- #{type}" unless malt_class
    malt_class.new(options.merge(:text=>text,:file=>file,:type=>type))
  end

  #
  def self.open(url, options={})
    require 'open-uri'
    text = open(url).read
    file = File.basename(url) # parse better with URI.parse
    text(text, :file=>file)
  end

  #
  def self.main(*args)
    require 'optparse'
    itype, otype = nil, nil
    OptionParser.new{|o|
      o.on('-t TYPE', 'input type'){  |t| itype  = t }
      o.on('-o TYPE', 'output type'){ |t| otype = t }
      o.on('--help', '-h'       , 'display this help message'){ puts o; exit }
    }.parse!
    db, files = *args.partition{ |x| x.index('=') }
    db = db.inject({}){ |h,kv| k,v = kv.split('='); h[k] = v; h}
    files.each do |file|
      puts Malt.render(:file=>file, :type=>itype, :format=>otype)
      #file = itype ? Malt.file(file, :type=>itype) : Malt.file(file)
      #if otype
      #  puts file.render(otype, db)
      #else
      #  puts file.render(db)
      #end
    end
  end

end

require 'malt/engines'
require 'malt/formats'
