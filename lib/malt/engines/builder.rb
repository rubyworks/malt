require 'malt/engines/abstract'

module Malt::Engine

  # Builder
  #
  #   http://builder.rubyforge.org/
  #
  class Builder < Abstract

    default :builder, :rbml

    #
    def render(params={}, &content)
      into = parameters(params, :to) || :html

      case into
      when :xml, :html, :xhtml
        prepare_engine(params, &content) #.target!
      else
        super(params, &content)
      end
    end

  #private

    # Prepare engine for rendering.
    def prepare_engine(params={}, &content)
      prefix = parameters(params, :prefix)

      if prefix
        prepare_engine_prefix(params, &content)
      else
        prepare_engine_scope(params, &content)
      end
    end

    # TODO: Can Builder be cached?

    #
    def create_engine(params={})
      opts = engine_options(params)

      #cached(opts) do
        ::Builder::XmlMarkup.new(opts)
      #end
    end

    #
    def prepare_engine_prefix(params, &content)
      prefix, text, file, scope, locals = parameters(params, :prefix, :text, :file, :scope, :locals)

      bind = make_binding(scope, locals, &content)

      #scope, locals = split_data(data)

      #scope  ||= Object.new
      #locals ||= {}

      engine = create_engine(params)

      code = %{
        lambda do |#{prefix}|
          #{text}
        end
      }

      eval(code, bind, file || '(builder)').call(engine)
    end

    # TODO: woud rather set instance variable via #instance_variable_set
    # but it is not defined.

    #
    def prepare_engine_scope(params, &content)
      text, file, scope, locals = parameters(params, :text, :file, :scope, :locals)

      scope, locals = make_external(scope, locals, &content)

      engine = create_engine

      locals.each do |k,v|
        next if k.to_sym == :target
        engine.instance_eval("@#{k} = v")
      end

      unless scope.respond_to?(:to_struct)
        scope.instance_variables.each do |k|
          next if k == "@target"
          v = scope.instance_variable_get(k)
          engine.instance_eval("#{k} = v") 
        end
      end

      engine.instance_eval(text, file || '(builder)')

      engine.target!
    end

  private

    # Load Builder library if not already loaded.
    def require_engine
      return if defined? ::Builder
      require_library 'builder'

      # Inexplicably Ruby 1.8 acts like the p method is present
      # if undef_method is not used, but acts like it isn't if
      # undef_method is used (raising an error).
      ::Builder::XmlBase.class_eval do
        undef_method :p rescue nil
      end
    end

    #
    # :target=>target_object: Object receiving the markup. target_object must
    # respond to the <<(a_string) operator and return itself.
    # The default target is a plain string target.
    #
    # :indent=>indentation: Number of spaces used for indentation. The default
    # is no indentation and no line breaks.
    #
    # :margin=>initial_indentation_level: Amount of initial indentation
    # (specified in levels, not spaces). 
    #
    def engine_option_names
      [:target, :indent, :margin]
    end

  end

end

