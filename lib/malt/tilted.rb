module Malt

  # Tilt compatability layer.
  module Tilted

    #
    module Tilt

      #
      def self.new(file, options={})
        Malt.file(file, options)
      end

      #
      ERBTemplate  = Malt::Format::ERB

      #
      HAMLTemplate = Malt::Format::HAML

    end

  end

end

# Include in toplevel space.
include Tilted

