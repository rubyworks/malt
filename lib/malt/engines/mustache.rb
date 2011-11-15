require 'malt/engines/abstract'

module Malt::Engine

  # Mustache engine.
  #
  # @see http://github.com/defunkt/mustache
  #
  class Mustache < Abstract

    register :mustache

    #
    def render(params={}, &yld) #file, db, &yld)
      text, data = parameters(params, :text, :data)

      data = make_hash(data, &yld)

      #engine = intermediate(params)
      #engine.render(data)

      ::Mustache.render(text, data)
    end

    #
    #def intermediate(params)
    #  text = parameters(params, :text)
    #  ???
    #end

  private

    # Load rdoc makup library if not already loaded.
    def initialize_engine
      return if defined? ::Mustache
      require_library 'mustache'
    end

  end

end


