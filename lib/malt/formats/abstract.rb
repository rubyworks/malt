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

      exts.each do |ext|
        Abstract.module_eval %{
          def #{ext}(*db,&yld)
            convert(:#{ext},*db,&yld)
          end
        }
      end
    end

    #
    def self.extensions
      @extensions
    end

    ;;;; private ;;;;

    #
    def initialize(options={})
      @options = options.rekey
      @type = @options[:type]
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
      @file ||= options[:file]
    end

    #
    def type
      @type ||= File.extname(file)
    end

    #
    def method_missing(s, *a, &b)
      convert(s, *a, &b)
    end

    #
    def convert(to, db={}, &yld)
      output = render(to, db, &yld)
      if subclass = Malt.registry[subtype]
        subclass.new(:text=>output, :file=>file.chomp(type)).convert(to, db, &yld)
      else
        subclass = Malt.registry['.' + to.to_s]
        subclass.new(:text=>output, :file=>refile(to), :fallback=>true)
      end
    end

    # Unless otherwise overridden, nothing happens and +self+
    # is returned.
    def render(to, db, &yld)
      self
    end

    # Produce a new filename replacing old extension with new
    # extension.
    #
    # type - Symbol representation of extension (e.g. :html).
    #
    # Returns a String of the new file name.
    def refile(type)
      type = type.to_s.sub(/^\./,'')
      if file
        fext = self.class.extensions.find{|e| file.end_with?(e)}
        new_file = file.chomp(fext) + type
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

    #
    #def to_html
    #  raise "not implemented for #{self.class} markup format"
    #end

    #
    #def to_latex
    #  raise "not implemented for #{self.class} markup format"
    #end

    #
    #def to_pdf
    #  raise "not implemented for #{self.class} markup format"
    #end

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

