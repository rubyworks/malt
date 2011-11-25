require 'malt/engines/abstract'

module Malt::Engine

  # Erubis template implementation.
  #
  #   http://www.kuwata-lab.com/erubis/
  #
  # Erubis is essentially compatibel with ERB, but it is faster.
  #
  class Erubis < Abstract

    register :erb, :rhtml, :eruby

    # Render template.
    def render(params, &content)
      text, file, data = parameters(params, :text, :file, :data)

      # NOTE: Erubis can handle hash data via result(:list=>data).
      # Would it be better to use that?

      bind = make_binding(data, &content)
      prepare_engine(params).result(bind)
    end

    #
    #def prepare_eninge(params={})
    #  create_engine(params)
    #end

    #
    def create_engine(params={})
      text, file, esc = parameters(params, :text, :file, :escape_html)

      opts = engine_options(params)

      cached(text, file, esc, opts) do
        if esc
          ::Erubis::EscapedEruby.new(text, opts)
        else
          ::Erubis::Eruby.new(text, opts)
        end
      end
    end

    # Compile template into Ruby source code.
    #def compile(params)
    #  if cache?
    #    @source[params] ||= intermediate(params).src
    #  else
    #    intermediate(params).src
    #  end
    #end

   private

    # Load ERB library if not already loaded.
    def require_engine
      return if defined? ::Erubius
      require_library('erubis')
    end
  
    #  
    ENGINE_OPTION_NAMES = %w{safe trim pattern preamble postable}

    #
    def engine_option_names
      ENGINE_OPTION_NAMES
    end

  end

end

