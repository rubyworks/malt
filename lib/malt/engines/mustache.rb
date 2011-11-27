require 'malt/engines/abstract'

module Malt::Engine

  # Mustache engine.
  #
  # @see http://github.com/defunkt/mustache
  #
  class Mustache < Abstract

    register :mustache

    #
    def render(params={}, &content) #file, db, &content)
      text, scope, locals = parameters(params, :text, :scope, :locals)

      locals = make_hash(scope, locals, &content)

      # convert symbol keys to strings w/o rewriting the hash
      symbol_keys = locals.keys.select{ |k| Symbol === k }
      symbol_keys.each do |k|
        locals[k.to_s] = locals[k]
        locals.delete(k)
      end

      #engine = intermediate(params)
      #engine.render(data)

      ::Mustache.render(text, locals)
    end

    #
    #def intermediate(params)
    #  text = parameters(params, :text)
    #  ???
    #end

  private

    # Load rdoc makup library if not already loaded.
    def require_engine
      return if defined? ::Mustache
      require_library 'mustache'
    end

  end

end


