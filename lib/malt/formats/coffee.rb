require 'malt/formats/abstract'
require 'malt/formats/javascript'
require 'malt/engines/coffee'

module Malt::Format

  # Coffee Format
  #
  class Coffee < Abstract

    register 'coffee'

    #
    def coffee(*)
      text
    end

    #
    def to_coffee(*)
      self
    end

    #
    def javascript(*data, &yielding)
      render_engine.render(:format=>:javascript, :text=>text, :file=>file, :data=>data, :type=>type, &yielding)
    end
    alias :js :javascript

    #
    def to_javascript(*data, &yielding)
      result = javascript(*data, &yielding)
      Javascript.new(:text=>result, :file=>refile(:js), :type=>:javascript)
    end
    alias :to_js :to_javascript

   private

    #
    def render_engine
      @render_engine ||= Malt::Engine::Coffee.new(options)
    end

    # Coffee default output type is Javascript.
    def default
      :javascript
    end

  end

end

