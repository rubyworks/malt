require 'malt/engines/abstract'

module Malt::Engine

  # WikiCloth is a MediaWiki format for Ruby. Unlike Creole, WikiCloth
  # also supports variable interpolation.
  #
  #@see http://code.google.com/p/wikicloth/

  class WikiCloth < Abstract

    default :wiki, :mediawiki, :mw

    #
    def render(params={}, &content)
      data = parameters(params, :data)

      data = make_hash(data, &content)

      case params[:to]
      when :html, nil
        prepare_engine(params).to_html(:params => data)
      else
        super(params)
      end
    end

    #
    def create_engine(params={})
      text = parameters(params, :text)

      cached(text) do
        ::WikiCloth::WikiCloth.new(:data => text)
      end
    end

    private

    # Load `wikicloth` library if not already loaded.
    def require_engine
      return if defined? ::WikiCloth
      require_library 'wikicloth'
    end

  end

end

