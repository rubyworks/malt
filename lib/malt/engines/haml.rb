require 'malt/engines/abstract'

module Malt::Engine

  # Haml
  #
  class Haml < Abstract

    default :haml

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
    def render_html(params, &yld)
      text = params[:text]
      file = params[:file]
      data = params[:data]

      engine = intermediate(params)
      case data
      when Binding
        html = engine.render(make_object(data), &yld)
      when Hash
        html = engine.render(Object.new, data, &yld)
      else
        if data.respond_to?(:to_hash)
          data = data.to_hash
          html = engine.render(Object.new, data, &yld)
        else
          html = engine.render(data || Object.new, &yld)
        end
      end
      html
    end

    #
    #def compile(text, file)
    #  intermediate # ??
    #end

    #
    def intermediate(params)
      text = params[:text]
      file = params[:file]
      ::Haml::Engine.new(text, :filename=>file)
    end

    private

    # Load Haml library if not already loaded.
    def initialize_engine
      return if defined? ::Haml::Engine
      require_library 'haml'
    end

  end

end

