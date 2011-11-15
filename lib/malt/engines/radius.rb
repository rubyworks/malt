require 'malt/engines/abstract'

module Malt::Engine

  # Radius Template
  #
  #   http://github.com/jlong/radius/
  #
  class Radius < Abstract

    default :radius

    #
    def render(params, &yld)
      into, text = parameters(params, :to, :text)

      case into
      when :html, :xml, nil
        context = intermediate(params, &yld)
        options = engine_options(params)

        parser = ::Radius::Parser.new(context, options)

        parser.parse(text)
      else
        super(params, &yld)
      end
    end

    #
    def intermediate(params={}, &yld)
      data = parameters(params, :data)

      if Array === data 
        if data.size > 1
          data = make_hash(data)
        else
          data = data.first
        end
      end

      make_context(data, &yld)
    end

  private

    # Load Radius library if not already loaded.
    def initialize_engine
      return if defined? ::Radius
      require_library 'radius'
    end

    # Radius templates have a very special data source.
    def make_context(data, &yld)
      case data
      when Hash
        context = make_context_from_hash(data, &yld)
      else
        if data.respond_to?(:to_hash)
          data = data.to_hash
          context = make_context_from_hash(data, &yld)
        else
          context = make_context_from_object(data, &yld)
        end
      end
      context
    end

    #
    def make_context_from_object(db, &yld)
      context = Class.new(::Radius::Context).new
      db = make_object(db)
      (class << context; self; end).class_eval do
        define_method :tag_missing do |tag, attr|
          db.__send__(tag) # any way to support attr as args?
        end
      end
      context.define_tag("yield") do
        yld.call
      end
      context
    end

    #
    def make_context_from_hash(data, &yld)
      context = Class.new(::Radius::Context).new
      #data = make_hash(data)
      data.each do |tag, value|
        context.define_tag(tag){ value }
      end
      context.define_tag("yield") do
        yld.call
      end
      context
    end

    #
    def engine_options(params)
      opts = {}
      opts[:tag_prefix] = params[:tag_prefix] || settings[:tag_prefix]
      opts
    end

  end

end
