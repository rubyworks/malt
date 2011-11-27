require 'malt/core_ext'
require 'malt/version'
require 'malt/kernel'
require 'malt/machine'

module Malt
  class << self
    include Malt::Kernel
  end

  #
  def self.machine
    @machine ||= Machine.new
  end

  # Render a file.
  def self.file(file, options={})
    machine.file(file, options)
  end

  # Render text string.
  def self.text(text, options={})
    machine.text(text, options)
  end

  # Render a URL.
  def self.open(url, options={})
    machine.open(url, options)
  end

  # Render a document.
  #
  # param [Hash] params
  #   Rendering parameters.
  #
  # option params [Symbol] :to
  #   The format to which the file/text is to be rendered.
  #
  # option params [String] :file
  #   The file to be rendered. If `:text` is not given, this file must exist on disk
  #   so it can be read-in to fill in the `:text` option. If text is given, the file
  #   is only used to help determine type and clarify error messages.
  #
  # option params [String] :text
  #   The text to render. This option is required unless `:file` is given.
  #
  # option params [Symbol] :type
  #   The format of the text. This will be determined automatically by the `:file`
  #    option if it is given and has a recognized extension. Otherwise it needs
  #    be explicitly provided.
  #
  # option params [Hash,Object,Binding,Array] :data
  #   The data source used for evaluation. This can be a locals hash, a scope
  #   object or binding, or an array of a scope object/binding and locals hash.
  #   This option is split-up into :scope and :locals before passing on to 
  #   the redering engine.
  #
  # option params [Boolean] :pass
  #   If not a supported type return text rather than raise an error.
  #
  def self.render(params, &body)
    machine.render(params, &body)
  end

  # Returns `true` if the extension given is a recognized format.
  def self.format?(ext)
    machine.format?(ext)
  end

  # Returns `true` if the extension given is renderable.
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
