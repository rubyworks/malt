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

end

#require 'malt/markup'
#require 'malt/template'

require 'malt/engines'
require 'malt/formats'

