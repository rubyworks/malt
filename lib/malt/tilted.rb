require 'malt' unless defined?(Malt)

module Malt

  # Base class for the Tilt-like template classes.
  class Malted
    #
    def self.engine_index
      @@engine_index ||= {}
    end

    #
    def self.malt_engine(engine_class=nil)
      if engine_class
        @malt_engine = engine_class
        engine_index[@malt_engine] = self
      end
      @malt_engine
    end

    #
    def malt_engine
      self.class.malt_engine.new(@options)
    end

    #
    def initialize(file, options={})
      @file    = file
      @options = options || {}
    end

    #
    def render(*data, &yields)
      text = File.read(@file)
      malt_engine.render(:text=>text, :file=>@file, :data=>data, &yields)
    end
  end

  # Tilt compatability layer. This get included into the toplevel.
  module Tilted

    #
    module Tilt
      extend Malt::Kernel

      #
      def self.new(file, options={})
        ext = ext_to_type(File.extname(file))
        malt_engine = Malt::Engine.defaults[ext] || Malt::Engine.registry[ext].first
        tilt_engine = Malted.engine_index[malt_engine]
        tilt_engine.new(file, options)
      end


      class StringTemplate < Malted
        malt_engine Malt::Engine::String
      end


      # E R U B Y

      #
      class ERBTemplate < Malted
        malt_engine Malt::Engine::Erb
      end

      #
      class ErubisTemplate < Malted
        malt_engine Malt::Engine::Erubis
      end


      # C U R L E Y  B R A C K E T S

      class LiquidTemplate < Malted
        malt_engine Malt::Engine::Liquid
      end


      # H T M L

      #
      class RadiusTemplate < Malted
        malt_engine Malt::Engine::Radius
      end

      #
      class HAMLTemplate < Malted
        malt_engine Malt::Engine::Haml
      end


      # X M L

      #
      class BuilderTemplate < Malted
        malt_engine Malt::Engine::Builder
      end

      #
      class MarkabyTemplate < Malted
        malt_engine Malt::Engine::Markaby
      end

      #
      #class NokogiriTemplate < Malted
      #  malt_engine Malt::Engine::Nokogiri
      #end


      # R D O C

      #
      class RDocTemplate < Malted
        malt_engine Malt::Engine::RDoc
      end


      # T E X T I L E

      #
      class RedClothTemplate < Malted
        malt_engine Malt::Engine::RedCloth
      end


      # M A R K D O W N

      #
      class RDiscountTemplate < Malted
        malt_engine Malt::Engine::RDiscount
      end

      #
      class BlueClothTemplate < Malted
        malt_engine Malt::Engine::BlueCloth
      end

      #
      class KramdownTemplate < Malted
        malt_engine Malt::Engine::Kramdown
      end

      #
      class RedcarpetTemplate < Malted
        malt_engine Malt::Engine::Redcarpet
      end

      #
      class MarukuTemplate < Malted
        malt_engine Malt::Engine::Maruku
      end


      # C S S

      #
      class SassTemplate < Malted
        malt_engine Malt::Engine::Sass
        #
        def malt_engine
          options = @options.merge(:type=>:sass)
          self.class.malt_engine.new(options)
        end
      end

      #
      class ScssTemplate < Malted
        malt_engine Malt::Engine::Sass
        #
        def malt_engine
          options = @options.merge(:type=>:scss)
          self.class.malt_engine.new(options)
        end
      end

      class LessTemplate < Malted
        malt_engine Malt::Engine::Less
      end


      # S O U R C E  C O D E

      #
      class CoffeeScriptTemplate < Malted
        malt_engine Malt::Engine::Coffee
      end


      # W I K I

      #
      class CreoleTemplate < Malted
        malt_engine Malt::Engine::Creole
      end

      #
      class WikiClothTemplate < Malted
        malt_engine Malt::Engine::WikiCloth
      end

    end

  end

end

# Include in toplevel space.
include Malt::Tilted

