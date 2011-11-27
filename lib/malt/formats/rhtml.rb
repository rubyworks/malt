require 'malt/formats/abstract'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Format

  # RHTML is a variant of Erb files which are limited to conversion to HTML.
  class RHTML < Abstract

    file_extension 'rhtml'

=begin
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
=end

    #
    def html(*data, &content)
      render_into(:html, *data, &content)
      #render_engine.render(:text=>text, :file=>file, :data=>data, :to=>:html, &yld)
    end

    #
    def to_html(*data, &yld)
      text = html(data, &yld)
      opts = options.merge(:text=>text, :file=>refile(:html), :type=>:html)
      HTML.new(opts)
    end

   #private

    ##
    #def render_engine
    #  @render_engine ||= (
    #    case engine
    #    when :erubis
    #      Malt::Engine::Erubis.new(options)
    #    else
    #      Malt::Engine::Erb.new(options)
    #    end
    #  )
    #end

  end

end

