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

      require_engine
    end

    # Access to the options given to the initializer.
    attr :settings

    #
    def cache?
      !settings[:nocache]
    end

    #
    def render(params, &block)
      if into = params[:to]
        raise NotImplementedError, "unsupported rendering -- #{into}"
      else
        raise NotImplementedError, "unsupported rendering"
      end
    end

    # Prepare engine for rendering.
    def prepare_engine(params={}, &content)
      create_engine(params, &content)
    end

    # Instantiate engine class with engine options and template text,
    # if possible.
    #
    # The initialization MUST never include template data and should
    # support caching, if feasible.
    #
    def create_engine(params={})
      raise NotImplementedError, "not implemented"
    end

    # Convert a rendition to Ruby source code. Not all engines support compiling.
    #
    #def compile(*data, &content)
    #  raise NotImplementedError, "not implemented"
    #end

  private

    # Cached yield reuslt with given key if cache mode is active.
    #
    def cached(*key)
      if cache?
        @cache[key] ||= yield
      else
        yield
      end
    end

    # Override this to load template engine library and
    # prepare is for geeral usage.
    def require_engine
    end

    # Require template library.
    def require_library(path)
      require(path)
    end

    # - - -  D A T A  H A N D L I N G  - - -

    # Unlike +#scope_and_locals+, this method returns +nil+ for missing
    # scope or locals.
    #
    def split_data(data)
      scope, locals = *[data].flatten
      if scope.respond_to?(:to_hash)
        locals ||= {}
        locals = locals.merge(scope.to_hash)
        scope  = nil
      end
      return scope, locals
    end

    # Take a data source are return a scope object and locals hash.
    #
    # @param [Object,Binding,Hash,Array] data 
    #   The data source used for evaluation.
    #   If the data is an Array with more than one entry, the first element
    #   will be assumed to be an Object or Binding scope and the remaining
    #   entries hashes which will be merged into one hash.
    #
    # @return [Array<Object,Hash>] Two element array of scope object and data hash.
    def scope_and_locals(data, &content)
      scope, locals = split_data(data) #*[data].flatten

      locals ||= {}

      case scope
      when Binding
        vars   = scope.eval("local_variables")
        vals   = scope.eval("[#{vars.join(',')}]")
        locals = locals.merge(Hash[*vars.zip(vals).flatten])
        scope  = scope.eval("self")
      end

      if scope.respond_to?(:to_struct)
        locals = locals.merge(scope.to_struct.to_h)
        scope  = Object.new
      end

      if scope.respond_to?(:to_hash)
        locals = locals.merge(scope.to_hash)
        scope  = Object.new
      end

      scope ||= Object.new

      locals[:content] = content.call if content

      return scope, locals
    end

    # Take a data source are return a scope object and locals hash.
    #
    # @param [Object,Binding,Hash,Array] data 
    #   The data source used for evaluation.
    #   If the data is an Array with more than one entry, the first element
    #   will be assumed to be an Object or Binding scope and the remaining
    #   entries hashes which will be merged into one hash.
    #
    # @return [Array<Object,Hash>] Two element array of scope object and data hash.
    def external_scope_and_locals(data, &content)
      scope, locals = split_data(data) #*[data].flatten

      locals ||= {}

      case scope
      when Binding
        vars   = scope.eval("local_variables")
        vals   = scope.eval("[#{vars.join(',')}]")
        locals = locals.merge(Hash[*vars.zip(vals).flatten])
        scope  = scope.eval("self")
      end

      if scope.respond_to?(:to_struct)
        locals = locals.merge(scope.to_struct.to_h)
        #scope  = Object.new
      end

      if scope.respond_to?(:to_hash)
        locals = locals.merge(scope.to_hash)
        scope  = Object.new
      end

      scope ||= Object.new
      scope = make_object(scope || Object.new)

      locals[:scope]   = scope
      locals[:content] = content.call if content

      return scope, locals
    end

    # Convert scope and data into a Binding.
    #
    # @param [Object,Binding,Hash,Array] data
    #   The data source used for evaluation.
    #
    # @see #split_data
    #
    # @return [Object] The data and yield block converted to a Binding.
    def make_binding(data, &content)
      scope, locals = scope_and_locals(data, &content)
      scope.to_binding.with(locals)
    end

    # TODO: Simplify the #make_object method.

    # Convert data into an object.
    #
    # @param [Object,Binding,Hash,Array] data
    #   The data source used for evaluation.
    #
    # @return [Object] The data and yield block converted to an Object.
    def make_object(data)
      scope, locals = split_data(data)
      locals ||= {}

      case scope
      when nil
        hash = locals.to_hash.dup
        if hash.empty?
          Object.new
        else
          vars, vals = [], []
          hash.each_pair do |k,v|
            vars << k; vals << v
          end
          Struct.new(*vars).new(*vals)
        end
      when Binding
        Class.new(::BasicObject){
          define_method(:method_missing) do |s, *a|
            if locals.key?(s)
              locals[s]
            elsif locals.key?(s.to_s)
              locals[s.to_s]
            else
              scope.eval(s.to_s)
            end
          end
        }.new
      when Struct
        vars, vals = [], []
        scope.each_pair do |k,v|
          vars << k; vals << v
        end
        locals.each_pair do |k,v|
          vars << k; vals << v
        end
        Struct.new(*vars).new(*vals)
      else
        if scope.respond_to?(:to_hash)
          hash = scope.to_hash.merge(locals.to_hash)
          if hash.empty?
            Object.new
          else
            vars, vals = [], []
            hash.each_pair do |k,v|
              vars << k; vals << v
            end
            Struct.new(*vars).new(*vals)
          end
        else
          Class.new(::BasicObject){
            define_method(:method_missing) do |s, *a, &b|
              if locals.key?(s)
                locals[s]
              elsif locals.key?(s.to_s)
                locals[s.to_s]
              else
                scope.__send__(s.to_s, *a, &b)
              end
            end
          }.new
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
    def make_hash(data, &content)
      scope, locals = split_data(data)

      case scope
      when nil
        hash = locals || {}
      when Binding
        #hash = Hash.new{ |h,k| p h,k; h[k] = data.key?(k) ? data[k] : scope.eval(k) }
        hash = Hash.new{ |h,k| h[k] = scope.eval(k) }
      else
        if scope.respond_to?(:to_hash)
          hash = scope.to_hash.merge(data)
        else
          #hash = Hash.new{ |h,k| data.key?(k) ? data[k] : h[k] = scope.__send__(k) }
          hash = Hash.new{ |h,k| h[k] = scope.__send__(k) }
        end
      end

      hash = hash.merge(locals || {})

      if content
        hash[:content] = content.call.to_s  # rescue nil ?
      end

      hash
    end

    #
    #def make_scope_and_data(data, &content)
    #  scope, data = scope_vs_data(data)
    #  case scope
    #  when Binding
    #    vars  = scope.eval("local_variables")
    #    vals  = scope.eval("[#{vars.join(',')}]")
    #    data  = data.merge(Hash[*vars.zip(vals).flatten])
    #    scope = scope.eval("self")
    #  else
    #    scope ||= Object.new
    #  end
    #  return scope, data
    #end

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
