require 'malt/engines/abstract'

module Malt::Engines

  # Liquid
  #
  #   http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    default :liquid

    #
    def intermediate(params)
      text = params[:text]
      ::Liquid::Template.parse(text)
    end

    #
    def render(params={}, &yld) #file, db, &yld)
      text = params[:text]
      data = params[:data]
      data = make_hash(data, &yld)
      data = data.rekey{ |k| k.to_s }
      engine = intermediate(params)
      engine.render(data)
    end

    private

    # Load Liquid library if not already loaded.
    def initialize_engine
      return if defined? ::Liquid::Template
      require_library 'liquid'
    end

  end

end

