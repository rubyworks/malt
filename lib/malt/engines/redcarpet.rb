require 'malt/engines/abstract'

module Malt::Engine

  # Redcarpet Markdown implementation.
  #
  # @see https://github.com/tanoku/redcarpet
  #
  class Redcarpet < Abstract

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
      into, text = parameters(params, :to, :text)

      case into
      when :html, nil  # :man, :manpage
        if ::Redcarpet::VERSION < '2'
          prepare_engine(params).to_html
        else
          prepare_engine(params).render(text)
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
    # @option params [Boolean] :no_intra_emphasis 
    #   Do not parse emphasis inside of words. Strings such as `foo_bar_baz`
    #   will not generate `<em>` tags.
    #
    # @option params [Boolean] :tables
    #   Parse tables, PHP-Markdown style.
    #
    # @option params [Boolean] :fenced_code_blocks
    #   Parse fenced code blocks, PHP-Markdown style. Blocks delimited with
    #   three or more `~` or backticks  will be considered as code, without
    #   the need to be indented. An optional language name may be added at
    #   the end of the opening fence for the code block
    #
    # @option params [Boolean] :autolink
    #   parse links even when they are not enclosed in
    #   `<>` characters. Autolinks for the http, https and ftp
    #   protocols will be automatically detected. Email addresses
    #   are also handled, and http links without protocol, but
    #   starting with `www.`
    #
    # @option params [Boolean] :strikethrough
    #   parse strikethrough, PHP-Markdown style
    #   Two `~` characters mark the start of a strikethrough,
    #   e.g. `this is ~~good~~ bad`
    #
    # @option params [Boolean] :lax_html_blocks
    #   HTML blocks do not require to be surrounded
    #   by an empty line as in the Markdown standard.
    #
    # @option params [Boolean] :space_after_headers
    #   A space is always required between the
    #   hash at the beginning of a header and its name, e.g.
    #   `#this is my header` would not be a valid header.
    #
    # @option params [Boolean] :superscript
    #   parse superscripts after the `^` character;
    #   contiguous superscripts are nested together, and complex
    #   values can be enclosed in parenthesis, e.g. `this is the 2^(nd) time`
    #
    def create_engine(params={})
      return create_engine_1x(params) if ::Redcarpet::VERSION < '2'

      into, toc = parameters(params, :to, :toc)

      opts = engine_options(params)

      case into
      when :man, :manpage
        renderer = ::Redcarpet::Render::ManPage
      else
        if toc
          renderer = ::Redcarpet::Render::HTML_TOC
        else
          renderer = ::Redcarpet::Render::HTML
        end
      end

      cached(into, toc, opts) do
        ::Redcarpet::Markdown.new(renderer,)
      end
    end

    # For Recarpet v1.x.
    def create_engine_1x(params={})
      text = parameters(params, :text)

      cached(text) do
        ::Redcarpet.new(text) #, engine_options(params))
      end
    end

  private

    ENGINE_OPTION_NAMES = %w{
      no_intra_emphasis tables fenced_code_blocks autolink strikethrough
      lax_html_blocks space_after_headers superscript
    }

    # Load rdoc makup library if not already loaded.
    def require_engine
      return if defined? ::Redcarpet
      require_library 'redcarpet'
    end

    #
    def engine_option_names
      ENGINE_OPTION_NAMES
    end

  end

end


