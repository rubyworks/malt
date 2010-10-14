require 'malt/engines/abstract'

module Malt::Engine

  # Mustache engine.
  #
  #   http://github.com/defunkt/mustache
  #
  class Mustache < Abstract

    register :mustache

    ## Convert Markdown text to intermediate object.
    #def intermediate(params)
    #  text = params[:text]
    #  ???
    #end

    #
    def render(params={}, &yld) #file, db, &yld)
      text = params[:text]
      data = params[:data]

      data = make_hash(data, &yld)

      #engine = intermediate(params)
      #engine.render(data)
      ::Mustache.render(text, data)
    end


    private

    # Load rdoc makup library if not already loaded.
    def initialize_engine
      return if defined? ::Mustache
      require_library 'mustache'
    end

  end

end


