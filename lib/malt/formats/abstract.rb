require 'malt/kernel'

module Malt
module Formats

  # Abstract format class serves as the base
  # class for all other format classes.
  #
  class Abstract
    include Malt::Kernel

    # Register the class to an extension type.
    def self.register(*exts)
      @extensions = exts
      Malt.register(self, *exts)

      #exts.each do |ext|
      #  Abstract.module_eval %{
      #    def to_#{ext}(*db,&yld)
      #      convert(:#{ext},*db,&yld)
      #    end
      #  }
      #end
    end

    #
    def self.extensions
      @extensions
    end

    #
    def self.engine(set=nil)
      @engine = set if set
      @engine
    end

    ;;;; private ;;;;

    #
    def initialize(options={})
      @options = options.rekey
      @type    = @options[:type]
      initialize_engine
    end

    # Override this method to load rendering engine library.
    def initialize_engine
    end

    ;;;; public ;;;;

    # Access to the options given to the initializer.
    # Returns an OpenStruct object.
    attr :options

    # Document source text.
    def text
      @text ||= options[:text] || File.read(file)
    end

    # File name of document.
    def file
      @file ||= options[:file].to_s
    end

    # File extension (with prefixed dot).
    def type
      @type ||= File.extname(file)
    end

    # Specified engine to use for rendering.
    #
    # Keep in mind that the ability to specify the engine
    # varies based on engine, format and output format.
    def engine
      options[:engine] || self.class.engine
    end

    #
    def to(type, db=nil, &yld)
      __send__("to_#{type}", db, &yld)
    end

    # Render to default or given format.
    #
    # If the first argument is a Symbol it is considered the format, otherwise
    # it is taken to be the database for rendering template variables.
    def render(*db, &yld)
      case db.first
      when Symbol 
        to = db.shift
        db = db.first
      else
        to = default
        db = db.first
      end
      render_to(to, db, &yld)
    end

    #
    #def render_to(format, db=nil, &yld)
    #  render_engine.render(format, text, file, db, &yld)
    #end

    #
#    def method_missing(s, *a, &b)
#      case s.to_s
#      when /^to_/
#        convert($', *a, &b)
#      else
#        convert(s, *a, &b).to_s
#        #render_to(s, *a, &b)
#      end
#    #rescue
#    #  super(s, *a, &b)
#    #end
#    end

    #
    def convert(to, *db, &yld)
      db = db.first
      output = render_to(to, db, &yld)
      if subclass = Malt.registry[subtype]
        subclass.new(:text=>output, :file=>file.chomp(type)).convert(to, db, &yld)
      else
        subclass = Malt.registry[".#{to}"]
        subclass.new(:text=>output, :file=>refile(to), :fallback=>true)
      end
    end

    # Produce a new filename replacing old extension with new
    # extension.
    #
    # type - Symbol representation of extension (e.g. :html).
    #
    # Returns a String of the new file name.
    def refile(type=nil)
      if file
        if type
          type = type.to_s.sub(/^\./,'')
          fext = self.class.extensions.find{|e| file.end_with?(e)}
          new_file = file.chomp(fext) + type
        else
          fext = self.class.extensions.find{|e| file.end_with?(e)}
          new_file = file.chomp('.'+fext)
        end
      else
        new_file = nil
      end
      new_file
    end

    #
    def extensions
      self.class.extensions
    end

    #
    def subtype
      File.extname(file.chomp(type))
    end

    #
    def to_s
      text
    end

    # Default rendering type is +:html+. Override if it
    # differs for the subclassing format.
    def default
      :html
    end

  end

  #
  class UnsupportedConversion < Exception
    def initialize(from_type, to_type)
      @from_type = from_type
      @to_type   = to_type
      super()
    end
    def message
      "unsupported conversion: #{@from_type} -> #{@to_type}"
    end
  end

end
end

