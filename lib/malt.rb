module Malt

  #
  def self.register(maltclass, *extnames)
    extnames.each do |extname|
      extname = extname.to_s 
      extname = '.' + extname unless extname[0,1] == '.'
      registry[extname] = maltclass
    end
  end

  #
  def self.registry
    @registry ||= {}
  end

  #
  def self.file(file, options={})
    type  = File.extname(file)
    malt_class = registry[type]
    malt_class.new(options.merge(:file=>file))
  end

  #
  def self.text(text, options={})
    if file = options[:file]
      type = File.extname(file)
      type = nil if type.empty?
    end
    type ||= options[:type]
    malt_class = registry[type]
    malt_class.new(options.merge(:text=>text,:file=>file))
  end

  #
  def self.open(url, options={})
    require 'open-uri'
    text = open(url).read
    file = File.basename(url) # parse better with URI.parse
    text(text, :file=>file)
  end

  #
  def self.main(*files)
    files.each do |file|
      puts Malt.file(file).render
    end
  end

end

#require 'malt/markup'
#require 'malt/template'

require 'malt/engines'
require 'malt/formats'

