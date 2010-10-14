require 'malt/engines/abstract'

module Malt::Engine

  # Erector
  #
  #   http://erector.rubyforge.org/userguide.html
  #
  class Erector < Abstract

    default :erector

    #
    def intermediate(params)
      text = params[:text]
      Class.new(::Erector::Widget) do
        module_eval %{ def content; #{text}; end }
      end
    end

    #
    def render(params, &yld)
      format = params[:format]
      case format
      when :html, nil
        render_html(params, &yld)
      else
        super(params, &yld)
      end
    end

    #
    def render_html(params={}, &yld)
      #text = params[:text]
      file = params[:file]
      data = params[:data]
      data = make_hash(data, &yld)

      intermediate(params).new(data).to_html      
    end

    private

    # Load Erector library if not already loaded.
    def initialize_engine
      return if defined? ::Erector
      require_library 'erector'
    end

    #
    def engine_options(params)
      opts = {}
      opts
    end

  end

end

