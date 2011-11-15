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
    def render(params={}, &yld)
      text, file, data = parameters(params, :text, :file, :data)

      if settings[:precompile] == false
        warn "non-compiled ERB does not support yield" if yld
        binding = make_binding(data, &yld)  # Ruby needs to support lambda{ yield }
        intermediate(params).result(binding)
      else
        scope, data = make_scope_and_data(data)
        vars, vals  = data.keys, data.values
        ruby = compile(params)
        ruby = <<-END
          def ___erb(#{vars.join(',')})
            #{ruby}
          end
          method(:___erb)
        END
        if file
          eval(ruby, scope.to_binding, file).call(*vals, &yld)
        else
          eval(ruby, scope.to_binding).call(*vals, &yld)
        end
      end
    end

    # Compile ERB template into Ruby source code.
    #
    # @return [String] Ruby source code.
    def compile(params={})
      if cache?
        @source[params] ||= intermediate(params).src
      else
        intermediate(params).src
      end
    end

    # Returns instance of underlying ::ERB class.
    def intermediate(params={})
      text, file = parameters(params, :text, :file)

      opts = engine_options(params)
      safe = opts[:safe]
      trim = opts[:trim]

      if cache?
        @cache[file] ||= ::ERB.new(text, safe, trim)
      else
        ::ERB.new(text, safe, trim)
      end
    end

    private

    # Load ERB library if not already loaded.
    def initialize_engine
      return if defined? ::ERB
      require_library('erb')
    end

    def engine_options(params)
      opts = {}
      opts[:safe] = params[:safe] || settings[:safe]
      opts[:trim] = params[:trim] || settings[:trim]
      opts
    end

  end

end

