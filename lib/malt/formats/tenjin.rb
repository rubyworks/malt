require 'malt/formats/abstract_template'
require 'malt/formats/html'
require 'malt/engines/tenjin'

module Malt::Format

  # Tenjin
  #
  #   http://www.kuwata-lab.com/tenjin/
  #
  class Tenjin < AbstractTemplate

    register 'tenjin'

    def rb(*)
      render_engine.compile(text, file)
    end

    # Erb templates can be "precompiled" into Ruby templates.
    def to_rb(*)
      text = rb
      Ruby.new(:text=>text, :file=>refile(:rb), :type=>:rb)
    end

    alias_method(:to_ruby, :to_rb)

    #
    def html(data=nil, &yld)
      render(:html, data, &yld)
    end

    #
    def to_html(data=nil, &yld)
      new_text    = render(:html, data, &yld)
      new_file    = refile(:html)
      new_options = options.merge(:text=>new_text, :file=>new_file, :type=>:html)
      HTML.new(new_options)
    end

    private

    #
    def render_engine
      @render_engine ||= Malt::Engine::Tenjin.new(options)
    end

  end

end

