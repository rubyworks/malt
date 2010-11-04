raise "not used anymore"

require 'malt/kernel'
require 'malt/config'
require 'malt/core_ext'

module Malt

  extend Kernel

  # 
  def self.config
    @config ||= Config.new
  end

  # Render template.
  #
  # parameters[:file]   - File name of template. Used to read text.
  # parameters[:text]   - Text of template document.
  # parameters[:type]   - File type/extension used to look up engine.
  # parameters[:pass]   - If not a supported type return text rather than raise an error.
  # parameters[:engine] - Force the use of a this specific engine.
  # parameters[:to]     - Format to convert to (usual default is `html`).
  #
  def self.render(parameters={}, &body)
    type   = parameters[:type]
    file   = parameters[:file]
    text   = parameters[:text]
    engine = parameters[:engine]

    type   = file_type(file, type)
    text   = file_read(file) unless text

    engine_class = engine(type, engine)

    if engine_class
      parameters[:type] = type
      parameters[:text] = text

      engine = engine_class.new
      engine.render(parameters, &body)
    else
      if parameters[:pass]
        text
      else
        raise "no engine to handle `#{type}' format"      
      end
    end
  end

  #
  def self.engine(type, engine=nil)
    type   = ext_to_type(type)
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
        nil
      end
    end
  end

  #
  def self.file_type(file, type=nil)
    ext = type || File.extname(file)
    ext = ext.to_s.downcase
    if ext.empty?
      nil
    elsif ext[0,1] == '.'
      ext[1..-1].to_sym
    else
      ext.to_sym
    end
  end

  #
  #def self.ext_type(type)
  #  type.to_s.downcase.sub(/^\./,'').to_sym
  #end

  # TODO: Handle File objects and URLs.
  def self.file_read(file)
    File.read(file)
  end

end

