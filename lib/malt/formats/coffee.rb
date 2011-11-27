require 'malt/formats/abstract'
require 'malt/formats/javascript'
require 'malt/engines/coffee'

module Malt::Format

  # Coffee Format
  #
  class Coffee < Abstract

    file_extension 'coffee'

    #
    def coffee(*)
      text
    end

    #
    def to_coffee(*)
      self
    end

    #
    def javascript(*data, &content)
      #render_engine.render(:format=>:javascript, :text=>text, :file=>file, :data=>data, :type=>type, &yielding)
      render_into(:javascript, *data, &content)
    end

    alias :js :javascript

    #
    def to_javascript(*data, &content)
      result = javascript(*data, &content)
      Javascript.new(:text=>result, :file=>refile(:js), :type=>:javascript)
    end

    alias :to_js :to_javascript

   private

    #
    #def render_engine
    #  @render_engine ||= Malt::Engine::Coffee.new(options)
    #end

    # Coffee default output type is Javascript.
    def default
      :javascript
    end

  end

end

