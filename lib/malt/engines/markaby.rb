require 'malt/engines/abstract'

module Malt::Engine

  # Markaby
  #
  #   http://markaby.rubyforge.org/
  #
  class Markaby < Abstract

    default :markaby, :mab

    #
    #def intermediate(params)
    #  text = params[:text]
    #  eval("lambda{ #{text} }")
    #end

    #
    def render(params, &yld)
      format = params[:format]
      case format
      when :html, nil
        render_html(params, &yld)
      else
        super(params, &yld)
      end
    end

    #
    def render_html(params={}, &yld)
      text = params[:text]
      file = params[:file]
      data = params[:data]
      data = make_hash(data, &yld)
      builder = ::Markaby::Builder.new(data)
      builder.instance_eval(text).to_s
    end

    private

    # Load Markaby library if not already loaded.
    def initialize_engine
      return if defined? ::Markaby
      require_library 'markaby'
    end

  end

end

