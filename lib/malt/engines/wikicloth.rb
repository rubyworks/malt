require 'malt/engines/abstract'

module Malt::Engine

  # WikiCloth is a MediaWiki format for Ruby. Unlike Creole, WikiCloth
  # also supports variable interpolation.
  #
  #@see http://code.google.com/p/wikicloth/

  class WikiCloth < Abstract

    default :wiki, :mediawiki, :mw

    #
    def render(params={}, &yld)
      data = parameters(params, :data)

      data = make_hash(data, &yld)

      case params[:to]
      when :html, nil
        intermediate(params).to_html(:params => data)
      else
        super(params)
      end
    end

    #
    def intermediate(params={})
      text = parameters(params, :text)

      ::WikiCloth::WikiCloth.new(:data => text)
    end

    private

    # Load `wikicloth` library if not already loaded.
    def initialize_engine
      return if defined? ::WikiCloth
      require_library 'wikicloth'
    end

  end

end

