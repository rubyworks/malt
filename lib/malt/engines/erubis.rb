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
    def render(params, &yld)
      text, file, data = parameters(params, :text, :file, :data)

      # @note Erubis can handle hash data via result(:list=>data)
      #   but how to handle yield then too? 

      if settings[:precompile] == false
        warn "non-compiled ERB does not support yield" if yld
        binding = make_binding(data, &yld)
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
        args = [ruby, scope.to_binding, file].compact
        eval(*args).call(*vals, &yld)
      end
    end

    # Compile template into Ruby source code.
    def compile(params)
      if cache?
        @source[params] ||= intermediate(params).src
      else
        intermediate(params).src
      end
    end

    #
    def intermediate(params={})
      text, file, esc = parameters(params, :text, :file, :escape_html)

      opts = engine_options(params)

      if esc
        ::Erubis::EscapedEruby.new(text, opts)
      else
        ::Erubis::Eruby.new(text, opts)
      end
    end

   private

    # Load ERB library if not already loaded.
    def initialize_engine
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

