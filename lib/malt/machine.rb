module Malt

  # The Machine class encapsulates Malt's main methods
  # along with configuratable settings to control
  # which engines and formats are used for rendering.
  class Machine

    # List of markup types.
    # TODO: dynamically generate this list from classes.
    MARKUP_TYPES = [:rdoc, :markdown, :textile]

    # List of template types.
    # TODO: dynamically generate this list from classes.
    TEMPLATE_TYPES = [:erb, :liquid, :ruby]

    # New Malt Machine.
    #
    # * config[:types]    - list formats to handle
    # * config[:priority] - list of prioritized engines
    #
    def initialize(config={})
      if priority = config[:priority]
        priority.map!{ |e| e.to_sym }
      else
        priority = []
      end
      if types = config[:types] || config[:type]
        formats = {}
        engines = {}
        types.each do |type|
          k = ext_to_type(type)
          formats[k] = Malt::Format.registry[k]
          engines[k] = Malt::Engine.registry[k]
        end
      else
        formats = Malt::Format.registry #.dup
        engines = Malt::Engine.registry #.dup
      end
      @formats  = formats
      @engines  = engines
      @priority = priority
    end

    #
    def formats
      @formats
    end

    #
    def engines
      @engines
    end

    # Engine priorities.
    #
    # Returns an Array of symbolic engine names.
    def priority(type=nil)
      if type
        type = type.to_s.downcase.to_sym
        @priority.unshift(type)
        @priority.uniq!  # assuming first are kept
      end
      @priority
    end

    #
    def engine?(ext)
      type = ext_to_type(ext)
      engines.key?(type)
      ##ext  = ext.to_s
      ##type = ext.sub(/^\./, '').strip
      ##return false if type.empty?
      ###@registry.key?(ext.to_sym)
      ###Engine.registry[type.to_sym]
      ##Engine.registry.key?(type.to_sym)
    end

    #
    def format?(ext)
      type = ext_to_type(ext)
      formats.key?(type)
    end

    #
    def file(file, options={})
      type = options[:type] || options[:format] || File.extname(file)
      type = ext_to_type(type)
      malt_class = formats[type]
      raise "unkown type -- #{type}" unless malt_class
      malt_class.new(options.merge(:file=>file,:type=>type))
    end

    #
    def text(text, options={})
      if file = options[:file]
        ext = File.extname(file)
        ext = nil if ext.empty?
      end
      type = options[:type] || options[:format] || ext
      type = ext_to_type(type)
      malt_class = formats[type] || Format::Text  # :pass ?
      #raise "unkown type -- #{type}" unless malt_class
      malt_class.new(options.merge(:text=>text,:file=>file,:type=>type))
    end

    # Open a URL as a Malt Format object.
    def open(url, options={})
      require 'open-uri'
      text = open(url).read
      file = File.basename(url) # parse better with URI.parse
      text(text, :file=>file)
    end

    # Render template directly.
    #
    # parameters[:file]   - File name of template. Used to read text.
    # parameters[:text]   - Text of template document.
    # parameters[:type]   - File type/extension used to look up engine.
    # parameters[:pass]   - If not a supported type return text rather than raise an error.
    # parameters[:engine] - Force the use of a this specific engine.
    # parameters[:to]     - Format to convert to (usual default is `html`).
    #
    def render(parameters={}, &body)
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
          raise NoEngineError, "no engine to handle `#{type}' format"      
        end
      end
    end

    private

    #
    def engine(type, engine=nil)
      type = ext_to_type(type)
      #engine = engine || Malt.config.engine[type]  # FIXME
      case engine
      when Class
        #raise unless Engine.registry[type].include?(engine)
        engine
      when String, Symbol
        match = engine.to_s.downcase.to_sym
        #Engine.registry[type].find{ |e| e.basename.downcase == match }
        #engines[type].find{ |e| e.basename.downcase == match }
        engines[type].find{ |e| match == e.type }
      else
        if engines[type]
          #Engine.registry[type].first
          types = engines[type]
          if prior = types.find{ |e| priority.include?(e.type) }
            return prior
          end
          if default = Engine.defaults[type]           
            return default #if engine?(default.type)
          end
          types.first
        else
          nil
        end
      end
    end

    #
    def file_type(file, type=nil)
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
    #def ext_type(type)
    #  type.to_s.downcase.sub(/^\./,'').to_sym
    #end

    # TODO: Handle File objects and URLs.
    def file_read(file)
      File.read(file)
    end

    # Normal file extension to a symbol type reference.
    def ext_to_type(ext)
      ext = ext.to_s.downcase
      return nil if ext.empty?
      if ext[0,1] == '.'
        ext[1..-1].to_sym
      else
        ext.to_sym
      end
    end

  end

  #
  class NoEngineError < ArgumentError
  end

end
