require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/builder'
require 'malt/engines/markaby'
require 'malt/engines/nokogiri'
require 'malt/engines/erector'

module Malt::Format

  # Builder is the format common to Builder, Markaby, Erector and Nokogiri's Builder.
  # Although there are some variant features between them, they all support the
  # same general format. The format looks like a Markup format, but is in fact a 
  # templating system built out of Ruby code for creating XML/HTML documents.
  #
  # @see http://builder.rubyforge.org/
  # @see http://markaby.rubyforge.org/
  # @see http://erector.rubyforge.org/
  # @see http://nokogiri.org/
  #
  # To unite these different engines I have designated them a common file 
  # extension of `.rbml`.
  # 
  class Builder < Abstract

    register 'rbml', 'builder', 'nokogiri', 'mab', 'markaby', 'erector'

    #
    def builder(*)
      text
    end
    alias_method :rbml, :builder

    #
    def to_builder(*)
      self
    end
    alias_method :to_rbml, :to_builder

    #
    def html(*data, &yld)
      render_engine.render(:to=>:html, :text=>text, :file=>file, :data=>data, &yld)
    end

    #
    def to_html(*data, &yld)
      text = html(*data, &yld)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

    #
    #def to_ruby(db, &yld)
    #  @ruby ||= (
    #    source = engine.compile(text, file)
    #    Ruby.new(:text=>source, :file=>refile(:rb))
    #  )
    #end

  private

    # TODO: allow the type to influence the engine selection
    #
    def render_engine
      @render_engine ||= (
        case engine
        when :erector
          Malt::Engine::Erector.new(options)
        when :builder
          Malt::Engine::Builder.new(options)
        when :markaby, :mab
          Malt::Engine::Markaby.new(options)
        else
          Malt::Engine::Nokogiri.new(options)
        end
      )
    end

  end

end

