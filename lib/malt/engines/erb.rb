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
    # The +params+ can be:
    #
    # * :text - text of erb document
    # * :file - file name where text was read (or nil)
    # * :data - data source for template interpolation
    # * :safe -
    # * :trim - trim mode
    #
    # Returns a String.
    def render(params={}, &yld)
      text  = params[:text]
      file  = params[:file]
      data  = params[:data] 

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

    # Compile ERB template into Ruby source code.
    def compile(params={})
      file = params[:file]
      if cache?
        @source[file] ||= intermediate(params).src
      else
        intermediate(params).src
      end
    end

    # Returns instance of underlying ::ERB class.
    def intermediate(params={})
      text = params[:text]
      file = params[:file]

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

