require 'malt/kernel'

module Malt
module Engines

  class << self
    include Malt::Kernel
  end

  #
  def self.register(malt_class, *exts)
    exts.each do |ext|
      type = ext_to_type(ext)
      registry[type] ||= []
      registry[type] << malt_class
      registry[type].uniq!
    end
  end

  #
  def self.registry
    @registry ||= {}
  end


  # Abstract Template class serves as the base
  # class for all other Template classes.
  #
  class Abstract
    include Malt::Kernel

    # Register the class to an extension type.
    def self.register(*exts)
      Engines.register(self, *exts)
    end

    # Register and set as the default for given extensions.
    def self.default(*exts)
      register(*exts)
      exts.each do |ext|
        Malt.config.engine[ext.to_sym] = self
      end
    end

    # Override this method to load rendering engine library.
    def initialize(settings={})
      @settings = settings.rekey

      @cache  = {}
      @source = {}

      initialize_engine
    end

    # Access to the options given to the initializer.
    # Returns an OpenStruct object.
    attr :settings

    #
    def render(text, options={}) #format, text, file, db, &yld)
      if format = options[:format]
        raise "unsupported rendering -- #{format}"
      else
        raise "unsupported rendering"
      end
    end

    #
    def compile(db, &yld)
      raise "not implemented"
    end

    #
    def cache?
      !settings[:nocache]
    end

    ;;;; private ;;;;

    # Override this to load template engine library and
    # prepare is for geeral usage.
    def initialize_engine
    end

    # Require template library.
    def require_library(path)
      require(path)
    end

    # Convert a data source into a Binding.
    # TODO: handle yld.
    def make_binding(db, &yld)
      return db if Binding === db

      if db.respond_to?(:to_binding)
        return db.to_binding
      end

      db = make_object(db)

      return db.instance_eval{ binding }        
    end

    # Convert a data source into an Object (aka a "scope").
    def make_object(db)
      if db.respond_to?(:to_hash)
        hash  = db.to_hash
        attrs = hash.keys.map{ |k| k.to_sym }
        return Struct.new(*attrs).new(*hash.values)
      end

      if Binding === db
        eval('self', binding)
      end

      return db
    end

    # Convert a data source into a Hash.
    def make_hash(db, &yld)
      if Binding === db
        db = make_object(db)
      end

      if db.respond_to?(:to_hash)
        db = db.to_hash
        db[:yield] = yld.call if yld
        return db
      end

      if db.respond_to?(:to_h)
        db = db.to_h
        db[:yield] = yld.call if yld
        return db
      end

      # last resort
      db = db.instance_variables.inject({}) do |h, i|
        k = i.sub('@','').to_sym
        v = instance_variable_get(i)
        h[k] = v
        h
      end
      db[:yield] = yld.call
      return db
    end

  end

end
end
