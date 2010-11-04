require 'malt/meta/data'
require 'malt/kernel'
require 'malt/machine'
require 'malt/core_ext'

module Malt

  class << self
    include Malt::Kernel
  end

  #
  def self.machine
    @machine ||= Machine.new
  end

  #
  def self.file(file, options={})
    machine.file(file, options)
  end

  #
  def self.text(text, options={})
    machine.text(text, options)
  end

  #
  def self.open(url, options={})
    machine.open(url, options)
  end

  #
  def self.render(params, &body)
    machine.render(params, &body)
  end

  #
  def self.format?(ext)
    machine.format?(ext)
  end

  # Returns true if the extension given is renderable.
  def self.engine?(ext)
    machine.engine?(ext)
  end

  #
  def self.cli(*args)
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
