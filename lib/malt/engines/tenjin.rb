require 'malt/engines/abstract'

module Malt::Engines

  # Tenjin
  #
  #   http://www.kuwata-lab.com/tenjin/
  #
  # options
  #   :escapefunc=>'CGI.escapeHTML'
  #
  class Tenjin < Abstract

    default :tenjin, :rbhtml

    #
    def render(params, &yld)
      text   = params[:text]
      file   = params[:file]
      data   = params[:data]
      type   = params[:type]
      format = params[:format] || :html

      return super(params, &yld) if type == :rbhtml && format != :html

      data = make_hash(data, &yld)
      template = intermediate(params)
      template.convert(text, file)

      template.render(data)
    end

    #
    def compile(params)
      text = params[:text]
      file = params[:file]
      intermediate(params).convert(text, file) 
    end

    private

    def intermediate(params)
      ::Tenjin::Template.new(nil, engine_options(params))
    end

    # Load Liquid library if not already loaded.
    def initialize_engine
      return if defined? ::Tenjin::Engine
      require_library 'tenjin'
    end

    def engine_options(params)
      opts = {}
      opts[:escapefunc] = params[:escapefunc] || settings[:escapefunc]
      opts
    end

  end

end

