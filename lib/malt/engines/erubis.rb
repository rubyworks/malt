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
      text = params[:text]
      file = params[:file]
      data = params[:data]

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
        eval(ruby, scope.to_binding, file).call(*vals, &yld)
      end
    end

    # Compile template into Ruby source code.
    def compile(params)
      file = params[:file]
      if cache?
        @source[file] ||= intermediate(params).src
      else
        intermediate(params).src
      end
    end

    #
    def intermediate(params)
      text = params[:text]
      file = params[:file]

      opts = engine_options(params)

      if params[:escape_html] || settings[:escape_html]
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
    def engine_options(params)
      opts = {}
      %w{safe trim pattern preamble postable}.each do |o|
        s = o.to_sym
        opts[s] = params[s] || settings[s]
      end
      opts
    end

  end

end

