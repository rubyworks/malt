require 'malt/kernel'

module Malt
module Engine

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

  #
  def self.defaults
    @defaults ||= {}
  end

  # Abstract Template class serves as the base
  # class for all other Template classes.
  #
  class Abstract
    include Malt::Kernel

    # Register the class to an extension type.
    def self.register(*exts)
      Engine.register(self, *exts)
    end

    # Register and set as the default for given extensions.
    def self.default(*exts)
      register(*exts)
      exts.each do |ext|
        Engine.defaults[ext.to_sym] = self
      end
    end

    #
    def self.type
      basename.downcase.to_sym
    end

    #
    def initialize(settings={})
      @settings = settings.rekey

      @cache  = {}
      @source = {}

      initialize_engine
    end

    # Access to the options given to the initializer.
    attr :settings

    #
    def render(params, &block)
      if into = params[:to]
        raise NotImplementedError, "unsupported rendering -- #{into}"
      else
        raise NotImplementedError, "unsupported rendering"
      end
    end

    # Convert a rendition to Ruby source code. Not all engines support compiling.
    #
    def compile(*data, &yields)
      raise NotImplementedError, "not implemented"
    end

    # The intermedate object of an engine is an instanceof the engine's
    # rendering class with initial setup options and template text preset.
    #
    # The intermediate object should never include data.
    #
    # In the future, this will be used with a cache to apply different datasets
    # over the same intermediate renderer.
    def intermediate(*)
      raise NotImplementedError, "not implemented"
    end

    #
    def cache?
      !settings[:nocache]
    end

    private

    # Override this to load template engine library and
    # prepare is for geeral usage.
    def initialize_engine
    end

    # Require template library.
    def require_library(path)
      require(path)
    end

    # Take a data source are return a scope object and data hash.
    #
    # @param [Object,Binding,Hash,Array] data 
    #   The data source used for evaluation.
    #   If the data is an Array with more than one entry, the first element
    #   will be assumed to be an Object or Binding scope and the remaining
    #   entries hashes which will be merged into one hash.
    #
    # @return [Array<Object,Hash>] Two element array of scope object and data hash.
    def scope_vs_data(data)
      case data
      when Array
        if data.size > 1
          scope, *data = *data
          data = data.inject({}){ |h,d| h.update(d); h }
          return scope, data
        else
          data = data.first || {}
        end
      end

      scope = nil
      if !data.respond_to?(:to_hash)
        scope = data
        data  = {}
      end

      return scope, data
    end

    # Convert scope and data into a Binding.
    #
    # @param [Object,Binding,Hash,Array] data
    #   The data source used for evaluation.
    #
    # @see #scope_vs_hash
    #
    # @return [Object] The data and yield block converted to a Binding.
    def make_binding(data, &yields)
      scope, data = scope_vs_data(data)
      scope = Object.new unless scope
      scope.to_binding.with(data, &yields)
    end

    # Convert scope and data into a scope object.
    #
    # @param [Object,Binding,Hash,Array] data
    #   The data source used for evaluation.
    #
    # @see #scope_vs_hash
    #
    # @return [Object] The data and yield block converted to an Object.
    def make_object(data, &yields)
      scope, data = scope_vs_data(data)
      if scope  # TODO: this is the trickiest one
        scope = scope.eval('self') if Binding === scope
        adhoc = (class << scope; self; end)

        data.to_hash.each do |name,value|
          adhoc.__send__(:define_method, name){ value }
        end

        if yields  # TODO: this won't work!!!
          adhoc.__send__(:define_method, :yield, &yields)
        end
        scope
      else
        hash = data.to_hash.dup
        if hash.empty?
          Object.new
        else
          # TODO: how to handle yield ?
          hash[:yield] = yields.call if yields  # rescue nil ?
          attrs = hash.keys.map{ |k| k.to_sym }
          Struct.new(*attrs).new(*hash.values)
        end
      end
    end

    # Convert data source into a hash.
    #
    # @param [Object,Binding,Hash,Array] data
    #   The data source used for evaluation.
    #
    # @see #scope_vs_hash
    #
    # @return [Hash] The data and yield block converted to a Hash.
    def make_hash(data, &yields)
      scope, data = scope_vs_data(data)
      hash = if scope
               scope = scope.eval('self') if Binding === scope
               if scope.respond_to?(:to_hash)
                 scope.to_hash
               else # last resort
                 Hash.new{ |h,k| h[k] = scope.__send__(k) }
                 #scope.instance_variables.inject({}) do |h, i|
                 #  k = i.sub('@','').to_sym
                 #  v = instance_variable_get(i)
                 #  h[k] = v
                 #  h
                 #end
               end
             else
               {}
             end

      hash = hash.merge(data)

      if yields
        hash[:yield] = yields.call  # rescue nil ?
      end

      hash
    end

    #
    def make_scope_and_data(data, &yields)
      scope, data = scope_vs_data(data)
      scope ||= Object.new
      return scope, data
    end

    #
    def engine_options(params)
      opts = {}
      engine_option_names.each do |o|
        o = o.to_sym
        v = params[o] || settings[o]
        opts[o] = v if v
      end
      opts
    end

    # Override this.
    def engine_option_names
      []
    end

    # Helper method to get paramters.
    def parameters(params, *names)
      pvals = names.map do |name|
        params[name.to_sym] || settings[name.to_sym]
      end

      if names.size == 1
        return pvals.first
      else
        return *pvals
      end
    end

  end

end
end
