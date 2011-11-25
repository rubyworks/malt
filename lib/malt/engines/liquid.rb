require 'malt/engines/abstract'

module Malt::Engine

  # Liquid templates.
  #
  # @see http://liquid.rubyforge.org/
  #
  class Liquid < Abstract

    default :liquid

    #
    def render(params={}, &content) #file, db, &content)
      text, data = parameters(params, :text, :data)

      data = make_hash(data, &content)

      # convert symbol keys to strings w/o rewriting the hash
      symbol_keys = data.keys.select{ |k| Symbol === k }
      symbol_keys.each do |k|
        data[k.to_s] = data[k]
        data.delete(k)
      end

      engine = prepare_engine(params)

      engine.render(data)
    end

    #
    def create_engine(params={})
      text = parameters(params, :text)
      cached(text) do
        ::Liquid::Template.parse(text)
      end
    end

  private

    # Load Liquid library if not already loaded.
    def require_engine
      return if defined? ::Liquid::Template
      require_library 'liquid'
    end

  end

end

