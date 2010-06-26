require 'malt/engines/abstract'

module Malt::Engines

  # Radius Template
  #
  #   http://github.com/jlong/radius/
  #
  class Radius < Abstract

    #
    def render_html(text, file, db, &yld)
      db = make_context(db, &yld)
      parser = Radius::Parser.new(db, options)
      parser.parse(text)
    end

    ;;;; private ;;;;

    # Load Radius library if not already loaded.
    def initialize_engine
      return if defined? ::Radius
      require_library 'radius'
    end

    # Radius templates have a very special data source.
    def make_context(db, &yld)
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

    # This is alternative approach should the other
    # prove problematic for some reason. This one is
    # probably faster, but may be less capable b/c of
    # the Hash conversion.
    def make_context_from_hash(db, &yld)
      context = Class.new(::Radius::Context).new
      db = make_hash(db)
      db.each do |tag, value|
        context.define_tag(tag){ value }
      end
      context.define_tag("yield") do
        yld.call
      end
      context
    end

  end

end

