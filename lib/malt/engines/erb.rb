require 'malt/engines/abstract'

module Malt::Engines

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
    # * :text - 
    # * :data - data source for template interpolation
    # * :safe -
    # * :trim -
    #
    def render(params={}, &yld)
      text = params[:text]
      data = params[:data]
      data = make_binding(data, &yld)
      intermediate(params).result(data)
    end

    # Compile ERB template into Ruby source code.
    def compile(params={})
      intermediate(params).src
    end

    #
    def intermediate(params={})
      text = params[:text]
      opts = engine_options(params)
      safe = opts[:safe]
      trim = opts[:trim]
      ::ERB.new(text, safe, trim)
    end

    #
    def safe
      settings[:safe]
    end

    #
    def trim
      settings[:trim]
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

