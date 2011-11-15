require 'malt/engines/abstract'

module Malt::Engine

  # Erector
  #
  # @see http://erector.rubyforge.org/userguide.html
  #
  class Erector < Abstract

    default :erector

    #
    def render(params={}, &yld)
      into = params[:to]

      case into
      when :html, nil
        render_html(params, &yld)
      else
        super(params, &yld)
      end
    end

    #
    def render_html(params={}, &yld)
      file, data = parameters(params, :file, :data)
 
      data = make_hash(data, &yld)

      intermediate(params).new(data).to_html      
    end

    #
    def intermediate(params={})
      text = parameters(params, :text)

      Class.new(::Erector::Widget) do
        module_eval %{ def content; #{text}; end }
      end
    end

  private

    # Load Erector library if not already loaded.
    def initialize_engine
      return if defined? ::Erector
      require_library 'erector'
    end

  end

end

