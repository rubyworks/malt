require 'malt/engines/abstract'

module Malt::Engine

  # Sass Malt Engine
  #
  class Sass < Abstract

    default :sass, :scss

    #
    def render(params, &yld)
      into = parameters(params, :to)

      case into
      when :css, nil
        engine = intermediate(params)
        engine.render
      else
        super(params, &yld)
      end
    end

    #
    def intermediate(params)
      text, file, type = parameters(params, :text, :file, :type)

      params[:filename] = file
      params[:syntax]   = type

      ::Sass::Engine.new(text, engine_options(params))
    end

  private

    # Load Sass library if not already loaded.
    def initialize_engine
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

