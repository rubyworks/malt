require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Formats

  # RBHTML is a variant of Tenjin, but limited to HTML conversion.
  class RBHTML < Abstract

    register 'rbhtml'

    # RHTML templates can be "pre-compiled" into Ruby templates.
    def rb(*)
      render_engine.compile(:text=>text, :file=>file)
    end

    # RHTML templates can be "pre-compiled" into Ruby templates.
    def to_rb(*)
      text = rb
      Ruby.new(:text=>text, :file=>refile(:rb), :type=>:rb)
    end

    #
    alias_method(:to_ruby, :to_rb)

    #
    alias_method(:precompile, :to_rb)

    #
    def html(data=nil, &yld)
      render_engine.render(:text=>text, :file=>file, :data=>data, :format=>:html, &yld)
    end

    #
    def to_html(data=nil, &yld)
      text = html(data, &yld)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engines::Tenjin.new(options)
    end

  end

end

