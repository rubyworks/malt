require 'malt/engines/abstract'

module Malt::Engine

  # Markaby
  #
  # @see http://markaby.rubyforge.org/
  #
  class Markaby < Abstract

    default :markaby, :mab

    #
    def render(params, &yld)
      into = parameters(params, :to)

      case into
      when :html, nil
        render_html(params, &yld)
      else
        super(params, &yld)
      end
    end

    #
    def render_html(params={}, &yld)
      text, file, data = parameters(params, :text, :file, :data)

      data = make_hash(data, &yld)

      builder = ::Markaby::Builder.new(data)

      builder.instance_eval(text).to_s
    end

    #
    #def intermediate(params)
    #  text = params[:text]
    #  eval("lambda{ #{text} }")
    #end

  private

    # Load Markaby library if not already loaded.
    def initialize_engine
      return if defined? ::Markaby
      require_library 'markaby'
    end

  end

end

