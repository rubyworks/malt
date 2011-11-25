require 'malt/engines/abstract'

module Malt::Engine

  # ERB template implementation.
  #
  #   http://www.ruby-doc.org/stdlib/libdoc/erb/rdoc/classes/ERB.html
  #
  # ERB templates accept two options. +safe+ sets the safe mode for
  # rendering the template and +trim+ is a weird string that controls
  # a few rendering options --it can be '%' and/or '>' or '<>'.
  class Erb < Abstract

    default :erb, :rhtml

    # Render ERB template.
    #
    # @param [Hash] params
    #
    # @option params [String] :text
    #   Text of ERB document.
    #
    # @option params [String] :file
    #   The file name where text was read (or nil).
    #
    # @option params [Hash,Binding,Object,Array] :data
    #   Data source for template interpolation.
    #
    # @option params [Boolean] :safe
    #   Run in separate thread.
    #
    # @option params [String] :trim
    #   Trim mode, can be either of the following:
    #     a) `%`  enables Ruby code processing for lines beginning with `%`.
    #     b) `<>` omit newline for lines starting with `<%` and ending in `%>`.
    #     c) `>`  omit newline for lines ending in `%>`.
    # 
    # @option params [Boolean] :precompile (true)
    #   Precompile the ERB template. Default is `true`.
    #   Note that `yield` currently does work with non-compiled tempaltes.
    #
    # @return [String] Rendered output.
    #
    def render(params={}, &content)
      text, file, data = parameters(params, :text, :file, :data)

      #if settings[:compile] == true
      #else
        bind = make_binding(data, &content)
        prepare_engine(params).result(bind)
      #end
    end

    # Returns instance of underlying ::ERB class.
    #def prepare_engine(params={})
    #  create_engine(params)
    #end

    #
    def create_engine(params={})
      text = parameters(params, :text)

      opts = engine_options(params)
      safe = opts[:safe]
      trim = opts[:trim]

      cached(text,safe,trim) do
        ::ERB.new(text, safe, trim)
      end
    end

  private

    # Load ERB library if not already loaded.
    def require_engine
      return if defined? ::ERB
      require_library('erb')
    end

    def engine_options(params)
      opts = {}
      opts[:safe] = params[:safe] || settings[:safe]
      opts[:trim] = params[:trim] || settings[:trim]
      opts
    end

    # Compile ERB template into Ruby source code.
    #
    # @return [String] Ruby source code.
    #def compile(params={})
    #  if cache?
    #    @source[params] ||= (
    #      intermediate(params).src
    #    )
    #  else
    #    intermediate(params).src
    #  end
    #end

  end

end
