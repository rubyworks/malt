require 'malt/formats/abstract_template'
require 'malt/formats/html'
require 'malt/engines/erb'
require 'malt/engines/erubis'

module Malt::Format

  #
  class Erb < AbstractTemplate

    file_extension 'erb'

    # Technically #method_missing will pick this up, but since it is likely
    # to be the most commonly used, adding the method directly will provide
    # a small speed boost.
    #
    def html(*data, &content)
      render_into(:html, *data, &content)
    end

    # Technically #method_missing will pick this up, but since it is likely
    # to be the most commonly used, adding the method directly will provide
    # a small speed boost.
    def to_html(*data, &yld)
      new_text    = render(:html, *data, &yld)
      new_file    = refile(:html)
      new_options = options.merge(:text=>new_text, :file=>new_file, :type=>:html)
      HTML.new(new_options)
    end

    # TODO: compile, if we decide to support
=begin
    # TODO: Lookup engine from engine registry.
    def rb(*)
      render_engine.compile(:text=>text, :file=>file)
    end

    # Erb templates can be "pre-compiled" into Ruby templates.
    def to_rb(*)
      text = rb
      Ruby.new(:text=>text, :file=>refile(:rb))
    end

    #
    alias_method(:to_ruby, :to_rb)

    #
    alias_method :precompile, :to_rb
=end

   #private

    #
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
