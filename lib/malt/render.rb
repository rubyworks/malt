require 'malt/config'
require 'malt/core_ext'

module Malt

  # 
  def self.config
    @config ||= Config.new
  end

  #
  def self.render(parameters={}, &body)
    type   = parameters[:type]
    file   = parameters[:file]
    engine = parameters[:engine]

    type   = file_type(file) unless type
    text   = file_read(file) unless text
    engine = engine(type, engine).new

    parameters[:type] = type
    parameters[:text] = text

    engine.render(parameters, &body)
  end

  #
  def self.engine(type, engine=nil)
    type   = type.to_sym
    engine = engine || config.engine[type]
    case engine
    when Class
      #raise unless Engine.registry[type].include?(engine)
      engine
    when String, Symbol
      match = engine.to_s.downcase
      Engine.registry[type].find{ |e| e.basename.downcase == match }
    else
      if Engine.registry[type]
        Engine.registry[type].first
      else
        raise "no engine to handle `#{type}' format"
      end
    end
  end

  #
  def self.file_type(file)
    ext = File.extname(file)
    ext = ext.to_s.downcase
    if ext.empty?
      nil
    elsif ext[0,1] == '.'
      ext[1..-1].to_sym
    else
      ext.to_sym
    end
  end

  # TODO: Handle File objects and URLs.
  def self.file_read(file)
    File.read(file)
  end

end
