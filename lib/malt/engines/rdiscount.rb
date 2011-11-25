require 'malt/engines/abstract'
require 'malt/formats/rdoc'
require 'malt/formats/html'

module Malt::Engine

  # Discount Markdown implementation.
  #
  # @see http://github.com/rtomayko/rdiscount
  #
  # The +:smart+ and +:filter_html+ options can be set true
  # to enable those flags on the underlying RDiscount object.
  class RDiscount < Abstract

    default :markdown, :md

    # Convert Markdown text to HTML text.
    def render(params={})
      into = parameters(params, :to)

      case into
      when :html, nil
        prepare_engine(params).to_html
      else
        super(params)
      end
    end

    # Convert Markdown text to create_engine engine object.
    def create_engine(params={})
      text = parameters(params, :text)

      flags = engine_options(params)

      cached(text, flags) do
        ::RDiscount.new(text, *flags)
      end
    end

  private

    # Load rdoc makup library if not already loaded.
    def require_engine
      return if defined? ::RDiscount
      require_library 'rdiscount'
    end

    #
    def engine_options(params={})
      [:smart, :filter_html].select{ |flag| params[flag] || settings[flag] }
    end

  end

end

