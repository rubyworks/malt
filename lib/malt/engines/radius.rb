require 'malt/engines/abstract'

module Malt::Engine

  # Radius Template
  #
  #   http://github.com/jlong/radius/
  #
  class Radius < Abstract

    default :radius

    #
    def render(params, &content)
      into, text = parameters(params, :to, :text)

      case into
      when :html, :xml, nil
        context = prepare_engine(params, &content)
        options = engine_options(params)

        parser = ::Radius::Parser.new(context, options)
        parser.parse(text)
      else
        super(params, &content)
      end
    end

    #
    def prepare_engine(params={}, &content)
      data = parameters(params, :data)

      scope, locals = split_data(data)

      locals ||= {}

      # convert string keys to symbols w/o rewriting the hash
      string_keys = locals.keys.select{ |k| String === k }
      string_keys.each do |k|
        locals[k.to_sym] = data[k]
        locals.delete(k)
      end

      make_context(scope, locals, &content)
    end

  private

    # Load Radius library if not already loaded.
    def require_engine
      return if defined? ::Radius
      require_library 'radius'
    end

    # Radius templates have a very special data source.
    def make_context(scope, data, &content)
      case scope
      when nil
        context = make_context_from_hash(data, &content)
      when Binding
        context = make_context_from_binding(scope, data, &content)
      else
        context = make_context_from_object(scope, data, &content)
      end
      context
    end

    #
    def make_context_from_binding(scope, data, &content)
      context_class = Class.new(::Radius::Context)
      context_class.class_eval do
        define_method :tag_missing do |tag, attr|
          if data.key?(tag.to_sym)
            data[tag.to_sym]
          else
            scope.eval(tag)
          end
        end
      end
      context = context_class.new
      context.define_tag("content") do
        content ? content.call : ''
      end
      context
    end

    #
    def make_context_from_object(scope, data, &content)
      context_class = Class.new(::Radius::Context)
      context_class.class_eval do
        define_method :tag_missing do |tag, attr|
          if data.key?(tag.to_sym)
            data[tag.to_sym]
          else
            scope.__send__(tag) # any way to support attr as args?
          end
        end
      end
      context = context_class.new
      context.define_tag("content") do
        content ? content.call : ''
      end
      context
    end

    #
    def make_context_from_hash(data, &content)
      context_class = Class.new(::Radius::Context)
      context_class.class_eval do
        define_method :tag_missing do |tag, attr|
          data[tag.to_sym]
        end
      end
      context = context_class.new
      context.define_tag("content") do
        content ? content.call : ''
      end
      context
    end

    #
    def engine_options(params)
      opts = {}
      opts[:tag_prefix] = params[:tag_prefix] || settings[:tag_prefix] #|| 'r'
      opts
    end

  end

end
