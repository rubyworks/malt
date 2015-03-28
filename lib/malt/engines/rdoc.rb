require 'malt/engines/abstract'

module Malt::Engine

  # RDoc template.
  #
  #   http://rdoc.rubyforge.org/
  #
  # It's suggested that your program require 'rdoc/markup' and
  # 'rdoc/markup/to_html' at load time when using this template
  # engine.
  class RDoc < Abstract

    default :rdoc

    # Convert rdoc text to html.
    def render(params={})
      into, text = parameters(params, :to, :text)

      case into
      when :html, nil
        prepare_engine(params).convert(text).to_s
      else
        super(params)
      end
    end

    #
    def create_engine(params={})
      into = parameters(params, :to)

      opts = engine_options(params)
      opts['rdoc_include'] = []
      opts['static_path']  = []

      rdoc_opts = ::RDoc::Options.new
      rdoc_opts.init_with(opts)

      # TODO: Do we need to cache on options too (if there ever are any)?
      cached(into) do
        ::RDoc::Markup::ToHtml.new(rdoc_opts)
      end
    end

  private

    # Load rdoc makup library if not already loaded.
    def require_engine
      return if defined?(::RDoc::Markup)
      require 'rubygems' # hack
      gem 'rdoc', '> 3'
      require_library 'rdoc'
      #require_library 'rdoc/markup'
      #require_library 'rdoc/markup/to_html'
    end

    # TODO: Which of these options are actually useful for convert RDoc to HTML?
    #
    #  charset
    #  exclude
    #  generator_name
    #  hyperlink_all
    #  line_numbers
    #  locale_name
    #  locale_dir
    #  main_page
    #  markup
    #  op_dir
    #  show_hash
    #  tab_width
    #  template_dir
    #  title
    #  visibility
    #  webcvs
    #
    ENGINE_OPTION_NAMES = %w{
      charset
      generator_name
      hyperlink_all
      line_numbers
      locale_name
      locale_dir
      markup
      tab_width
      title
      visibility
      webcvs
    }

    #
    def engine_option_names
      ENGINE_OPTION_NAMES
    end

  end

end

