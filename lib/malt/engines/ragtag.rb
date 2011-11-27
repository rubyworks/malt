require 'malt/engines/abstract'

module Malt::Engine

  # RagTag XML/HTML templates.
  #
  # @see http://github.com/rubyworks/ragtag
  #
  class RagTag < Abstract

    default :ragtag, :rt

    #
    def render(params={}, &content)
      into = parameters(params, :to) || :html

      case into
      when :html
        prepare_engine(params,&content).to_html
      when :xhtml
        prepare_engine(params,&content).to_xhtml
      when :xml
        prepare_engine(params,&content).to_xml
      else
        super(params, &content)
      end
    end

    # 
    def prepare_engine(params={}, &content)
      text, file, scope, locals = parameters(params, :text, :file, :scope, :locals)

      binding = make_binding(scope, locals, &content)

      create_engine(params).compile(binding)
    end

    #
    def create_engine(params={})
      text = parameters(params, :text)

      cached(text) do
        ::RagTag.new(text)
      end
    end

    private

    # Load Haml library if not already loaded.
    def require_engine
      return if defined? ::RagTag
      require_library 'ragtag'
    end

  end

end
