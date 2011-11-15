require 'malt/engines/abstract'

module Malt::Engine

  # Kramdown Markdown implementation.
  #
  #   http://kramdown.rubyforge.org/
  #
  class Kramdown < Abstract

    register :markdown, :md

    # Convert Markdown text to HTML text.
    #
    # @param [Hash] params
    #   A hash containing the Markdown extensions which the parser
    #   will identify. The following extensions are accepted.
    #
    # @option params [String] :text
    #   Template text.
    #
    # @option params [String,Symbol] :to ('html')
    #   Type or file extension to convert template into.
    #
    # @see http://kramdown.rubyforge.org/rdoc/Kramdown/Options.html
    #
    def render(params)
      text = params[:text]
      into = params[:to]
      case into
      when :html, nil
        intermediate(params).to_html
      when :latex
        intermediate(params).to_latex
      else
        super(params)
      end
    end

    # Convert Markdown text to intermediate object.
    def intermediate(params)
      text = params[:text]
      ::Kramdown::Document.new(text)
    end

    private

      # Load rdoc makup library if not already loaded.
      def initialize_engine
        return if defined? ::Kramdown
        require_library 'kramdown'
      end

      # Kramdown has lots of options!
      ENGINE_OPTION_NAMES = %w{
        auto_id_prefix auto_ids
        coderay_bold_every coderay_css coderay_line_number_start
        coderay_line_numbers coderay_tab_width coderay_wrap
        entity_output footnote_nr html_to_native latex_headers
        line_width parse_block_html parse_span_html smart_quotes
        template toc_levels
      }

      #
      def engine_option_names
        ENGINE_OPTION_NAMES
      end

  end

end


