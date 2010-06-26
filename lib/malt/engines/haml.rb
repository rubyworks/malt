require 'malt/engines/abstract'

module Malt::Engines

  # Haml
  #
  class Haml < Abstract

    #
    def intermediate(text, file=nil)
      ::Haml::Engine.new(text, :filename=>file)
    end

    #
    #def compile(text, file)
    #  intermediate # ??
    #end

    #
    def render_html(text, file, db, &block)
      engine = intermediate(text, file)
      if Binding === db
        html = engine.render(make_object(db), &block)
      elsif db.respond_to?(:to_hash)
        html = engine.render(Object.new, db.to_hash, &block)
      else
        html = engine.render(db||Object.new, &block)
      end
      html
    end

    ;;;; private ;;;;

    # Load Haml library if not already loaded.
    def initialize_engine
      return if defined? ::Haml::Engine
      require_library 'haml'
    end

  end

end

