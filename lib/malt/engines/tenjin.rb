require 'malt/engines/abstract'

module Malt::Engine

  # Tenjin
  #
  # @see http://www.kuwata-lab.com/tenjin/
  #
  class Tenjin < Abstract

    default :tenjin, :rbhtml

    # Render Tenjin.
    #
    # @option params [String] :escapefunc
    #   Defaults to 'CGI.escapeHTML'.
    #
    def render(params, &yld)
      into, text, file, data, type = parameters(params, :to, :text, :file, :data, :type)

      into ||= :html

      return super(params, &yld) if type == :rbhtml && into != :html

      data = make_hash(data, &yld)

      engine = intermediate(params)
      engine.convert(text, file)

      engine.render(data)
    end

    #
    def compile(params)
      text, file = parameters(params, :text, :file)
      intermediate(params).convert(text, file) 
    end

    #
    def intermediate(params)
      file = parameters(params, :file)
      ::Tenjin::Template.new(file, engine_options(params))
    end

  private

    # Load Liquid library if not already loaded.
    def initialize_engine
      return if defined? ::Tenjin::Engine
      require_library 'tenjin'
    end

    #
    def engine_option_names
      [:escapefunc]
    end

  end

end

