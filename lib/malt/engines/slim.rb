require 'malt/engines/abstract'

module Malt::Engine

  # Haml
  #
  class Slim < Abstract

    default :slim

    #
    def render(params, &yld)
      into = params[:to]
      case into
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
        scope   = make_object(data)
        options = {}
      when Hash
        scope   = Object.new
        options = data
      else
        if data.respond_to?(:to_hash)
          scope   = Object.new
          options = data.to_hash
        else
          scope   = data || Object.new
          options = {}
        end
      end
      Slim::Template.new(options){text}.render(scope)
    end

    #
    #def compile(text, file)
    #  intermediate # ??
    #end

    #
    #def intermediate(params)
    #  text = params[:text]
    #  file = params[:file]
    #  ::Haml::Engine.new(text, :filename=>file)
    #end

    private

    # Load Haml library if not already loaded.
    def initialize_engine
      return if defined? ::Slim
      require_library 'slim'
    end

  end

end

