require 'malt/engines/abstract'

module Malt::Engine

  # Redcarpet Markdown implementation.
  #
  #   http://maruku.rubyforge.org/
  #
  class Maruku < Abstract

    register :markdown, :md

    # Convert Markdown text to HTML text.
    #
    # @param [Hash] params
    #
    # @option params [String] :text
    #   Template text
    #
    # @option params [String,Symbol] :to ('html')
    #   Type or file extension to convert template into.
    #
    def render(params={})
      into, text, part = parameters(params, :to, :text, :partial)

      engine = prepare_engine(params)

      case into
      when :html, nil
        if part
          engine.to_html
        else
          engine.to_html_document
        end
      when :latex #, :pdf
        if part
          engine.to_latex
        else
          engine.to_latex_document
        end
      else
        super(params)
      end
    end

    # Convert Markdown text to intermediate object.
    #
    # @param [Hash] params
    #   A hash containing the Markdown extensions which the parser
    #   will identify. The following extensions are accepted.
    #
    # @option params [Symbol] :on_error
    #   If :raise, then raise error.
    #
    def create_engine(params={})
      text = parameters(params, :text)
      opts = engine_options(params)

      ::Maruku.new(text, opts)
    end

    private

      # Supported engine options.
      #
      # @todo Add more options.
      #
      # @see http://maruku.rubyforge.org/exd.html
      #
      ENGINE_OPTION_NAMES = %w{
        math_enabled 
      }

      # Load rdoc makup library if not already loaded.
      def require_engine
        return if defined? ::Maruku
        require_library 'maruku'
      end

      #
      def engine_option_names
        ENGINE_OPTION_NAMES
      end

  end

end


