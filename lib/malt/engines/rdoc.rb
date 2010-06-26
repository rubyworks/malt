require 'malt/engines/abstract'

module Malt::Engines

  # RDoc template.
  #
  #   http://rdoc.rubyforge.org/
  #
  # It's suggested that your program require 'rdoc/markup' and
  # 'rdoc/markup/to_html' at load time when using this template
  # engine.
  class RDoc < Abstract

    # Convert rdoc text to html.
    def render_html(text, file=nil)
      html_engine.convert(text).to_s
    end

    ;;;; private ;;;;

    # Load rdoc makup library if not already loaded.
    def initialize_engine
      return if defined?(::RDoc::Markup)
      require 'rubygems' # hack
      require_library 'rdoc/markup'
      require_library 'rdoc/markup/to_html'
    end

    #
    def html_engine
      @html_engine ||= ::RDoc::Markup::ToHtml.new
    end

  end

end

