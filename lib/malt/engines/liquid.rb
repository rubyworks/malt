require 'malt/engines/abstract'

module Malt::Engine

  # Liquid templates.
  #
  # @see http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    default :liquid

    #
    def render(params={}, &yld) #file, db, &yld)
      text, data = parameters(params, :text, :data)

      data = make_hash(data, &yld)
      data = data.rekey{ |k| k.to_s }

      engine = intermediate(params)

      engine.render(data)
    end

    #
    def intermediate(params)
      text = parameters(params, :text)
      ::Liquid::Template.parse(text)
    end

  private

    # Load Liquid library if not already loaded.
    def initialize_engine
      return if defined? ::Liquid::Template
      require_library 'liquid'
    end

  end

end

