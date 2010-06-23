require 'malt/kernel'

module Malt
module Engines

  # Abstract Template class serves as the base
  # class for all other Template classes.
  #
  class Abstract
    include Malt::Kernel

    # Register the class to an extension type.
    def self.register(*exts)
      Malt.register(self, *exts)
    end

    # Override this method to load rendering engine library.
    def initialize(options={})
      @options = options.rekey
      initialize_engine
    end

    # Access to the options given to the initializer.
    # Returns an OpenStruct object.
    attr :options

    #
    def compile(db, &yld)
      raise "not implemented"
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
        hash = db.to_hash
        return Struct.new(*hash.keys).new(*hash.values)
      end

      if Binding === db
        eval('self', binding)
      end

      return db
    end

    # Convert a data source into a Hash.
    def make_hash(db)
      if Binding === db
        db = make_object(db)
      end

      if db.respond_to?(:to_hash)
        db.to_hash
      end

      if db.respond_to?(:to_h)
        return db.to_h
      end

      # last resort
      db.instance_variables.inject({}) do |h, i|
        k = i.sub('@','').to_sym
        v = instance_variable_get(i)
        h[k] = v
        h
      end
    end

  end

end
end
