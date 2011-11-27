require 'malt/engines/abstract'

module Malt::Engine

  # Sass Malt Engine
  #
  class Sass < Abstract

    default :sass, :scss

    #
    def render(params={}, &content)
      into = parameters(params, :to)

      case into
      when :css, nil
        engine = prepare_engine(params)
        engine.render
      else
        super(params, &content)
      end
    end

    #
    def create_engine(params={})
      text, file, type = parameters(params, :text, :file, :type)

      opts = engine_options(params)

      opts[:filename] = file
      opts[:syntax]   = type

      cached(text, file, type) do
        ::Sass::Engine.new(text, opts)
      end
    end

  private

    # Load Sass library if not already loaded.
    def require_engine
      return if defined? ::Sass::Engine
      require_library 'sass'
    end

    # List of Sass/Scss engine options. Note that not all options are supported.
    # Also use `:type` instead of `:syntax` and `:file` instead of `:filename`.
    #
    # @see http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#options
    ENGINE_OPTION_NAMES = %w{
      syntax filename line style unix_newlines
      line_numbers trace_selectors debug_info quiet 
    }

    #
    def engine_option_names
      ENGINE_OPTION_NAMES
    end

  end

end

