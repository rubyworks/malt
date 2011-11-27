require 'malt/kernel'

module Malt
module Format

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

  # Abstract format class serves as the base
  # class for all other format classes.
  #
  class Abstract
    include Malt::Kernel

    # Register the class to an extension type.
    def self.file_extension(*exts)
      @file_extensions = exts
      Malt::Format.register(self, *exts)

      #exts.each do |ext|
      #  Abstract.module_eval %{
      #    def to_#{ext}(*db,&yld)
      #      convert(:#{ext},*db,&yld)
      #    end
      #  }
      #end
    end

    # @deprecated
    def self.register(*exts)
      self.file_extension(*exts)
    end

    #
    def self.extensions
      @file_extensions
    end

    #--
    # TODO: warning: instance variable @engine not initialized
    #++
    def self.engine(set=nil)
      @engine = set if set
      @engine
    end

   private

    #
    def initialize(options={})
      @options = options.rekey

      @file = @options[:file]
      @text = @options[:text] || file_read(@file)
      @type = @options[:type] || file_type(@file)
    end

   public

    # Access to the options given to the initializer.
    attr :options

    # Change options on the fly.
    def with(options={})
      alt = dup
      alt.with!(options)
    end

    # Change options in-place.
    def with!(options)
      @options.update(options.rekey)
      self
    end

    # Document source text.
    def text
      @text
    end

    # File name of document.
    def file
      @file
    end

    # File extension (with prefixed dot).
    def type
      @type
    end

    # Specified engine to use for rendering.
    #
    # Keep in mind that the ability to specify the engine
    # varies based on engine, format and output format.
    def engine
      options[:engine] || self.class.engine
    end

    #
    def to(type, *data, &yld)
      __send__("to_#{type}", *data, &yld)
    end

    # Render to default or given format.
    #
    # If the first argument is a Symbol it is considered the format, otherwise
    # it is taken to be the data for rendering template variables.
    def render(*type_and_data, &yld)
      type, data = parse_type_from_data(*type_and_data)
      meth = method(type || default)
      #__send__(type || default, data, &yld)
      meth.arity == 0 ?  meth.call(&yld) :  meth.call(*data, &yld)
    end

    #
    def render_into(into, *data, &content)
      parameters = rendering_parameters(into, data)
      Malt.render(parameters, &content)
    end

    #
    def rendering_parameters(into, data)
      opts = options.merge(
        :to     => into,
        :data   => data,
        :text   => text,
        :file   => file,
        :engine => engine
      )
    end

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

    # TODO: render a file until add extension are exhusted
#    def convert(to, *db, &yld)
#      db = db.first
#      output = render_to(to, db, &yld)
#      if subclass = Malt.registry[subtype]
#        subclass.new(:text=>output, :file=>file.chomp(type)).convert(to, db, &yld)
#      else
#        subclass = Malt.registry[".#{to}"]
#        subclass.new(:text=>output, :file=>refile(to), :fallback=>true)
#      end
#    end

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
          new_file = file.chomp(fext) + '.' + type
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

    #
    def to_default(*data, &yld)
      to(default, *data, &yld)
    end

    # Default rendering type is +:html+. Override if it
    # differs for the subclassing format.
    def default
      :html
    end

    #
    def parse_type_from_data(*data)
      if Symbol === data.first
        type = data.shift
      else
        type = nil
      end
      return type, data
    end

    ##
    #def parse_type_scope_data(*data)
    #  if Symbol === data.first
    #    type = data.shift
    #  else
    #    type = nil
    #  end
    #  scope, data = scope_vs_data(*data)
    #  return type, scope, data
    #end

    # @deprecate
    def scope_vs_data(scope, data=nil)
      if scope && !data
        if scope.respond_to?(:to_hash)
          data  = scope
          scope = nil
        end
      end
      return scope, data
    end

    #
    def file_read(file)
      File.read(file)
    end

    #
    def file_type(file)
      if file
        File.extname(file)
      else
        nil
      end
    end

  end

  # TODO: Is this needed anymore, if so where?
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

