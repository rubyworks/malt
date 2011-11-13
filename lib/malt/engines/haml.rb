require 'malt/engines/abstract'

module Malt::Engine

  # Haml
  #
  class Haml < Abstract

    default :haml

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
      text  = params[:text]
      file  = params[:file]
      data  = params[:data]

      scope, data = make_object_and_hash(data)
      scope ||= Object.new

      engine = intermediate(params)
      engine.render(scope, data, &yld)

      #case data
      #when Binding
      #  raise ArgumentError, "redundant scope" if scope
      #  html = engine.render(make_object(data), &yld)
      #when Hash
      #  scope = scope || Object.new
      #  scope = scope.self if Binding === scope
      #  html = engine.render(scope, data, &yld)
      #else
      #  if data.respond_to?(:to_hash)
      #    data  = data.to_hash
      #    scope = scope || Object.new
      #    scope = scope.self if Binding === scope
      #    html  = engine.render(scope, data, &yld)
      #  else
      #    raise ArgumentError, "redundant scope" if data && scope
      #    html = engine.render(data || scope, &yld)
      #  end
      #end
      #html
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

