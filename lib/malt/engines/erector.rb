require 'malt/engines/abstract'

module Malt::Engine

  # The Erector template engine handles a builder-style template format.
  #
  # @see http://erector.rubyforge.org/userguide.html
  #
  # For Erector templates the data is passed in as attribute variables.
  #
  # A simple example template:
  #
  #    div do
  #      h1 @name
  #      div @state, :id=>'state'
  #      div @content, :id=>'yield'
  #    end
  #
  # IMPORTANT! Erecotor templates do not currently support scope.
  #
  class Erector < Abstract

    default  :erector
    register :rbml, :builder

    #
    def render(params={}, &content)
      into = params[:to] || :html

      case into
      when :html, :xhtml
        prepare_engine(params, &content).to_html
      else
        super(params, &content)
      end
    end

    # Return Erector parser, ready to render results.
    def prepare_engine(params={}, &content)
      file, data  = parameters(params, :file, :data)

      scope, locals = external_scope_and_locals(data, &content)

      #file = file || inspect

      unless scope.respond_to?(:to_struct)
        scope_locals = {}
        scope.instance_variables.each do |k|
          next if k == "@target"
          name = k.to_s.sub('@','').to_sym
          v = scope.instance_variable_get(k)
          scope_locals[name] = v
        end
        locals = scope_locals.merge(locals)
      end

      create_engine(params).new(locals)
    end

    # TODO: how to support scope ?

    # Erector constructor support caching.
    #
    def create_engine(params={})
      text, prefix = parameters(params, :text, :prefix)

      cached(prefix, text) do
        Class.new(::Erector::Widget) do
          module_eval %{
            def #{prefix}; self; end
          } if prefix

          module_eval %{
            def content
              #{text}
            end
          }
        end
      end
    end

  private

    # Load Erector library if not already loaded.
    def require_engine
      return if defined? ::Erector
      require_library 'erector'
    end

  end

end
