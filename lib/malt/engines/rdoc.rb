require 'malt/engines/abstract'

module Malt::Engine

  # RDoc template.
  #
  #   http://rdoc.rubyforge.org/
  #
  # It's suggested that your program require 'rdoc/markup' and
  # 'rdoc/markup/to_html' at load time when using this template
  # engine.
  class RDoc < Abstract

    default :rdoc

    # Convert rdoc text to html.
    def render(params={})
      into, text = parameters(params, :to, :text)

      case into
      when :html, nil
        prepare_engine(params).convert(text).to_s
      else
        super(params)
      end
    end

    #
    def create_engine(params={})
      into = parameters(params, :to)

      cached(into) do
        ::RDoc::Markup::ToHtml.new
      end
    end

  private

    # Load rdoc makup library if not already loaded.
    def require_engine
      return if defined?(::RDoc::Markup)
      require 'rubygems' # hack
      gem 'rdoc', '> 3'
      require_library 'rdoc'
      #require_library 'rdoc/markup'
      #require_library 'rdoc/markup/to_html'
    end

  end

end

