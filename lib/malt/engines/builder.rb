require 'malt/engines/abstract'

module Malt::Engine

  # Builder
  #
  #   http://builder.rubyforge.org/
  #
  class Builder < Abstract

    default :builder

    #
    #def intermediate(params)
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

    # TODO: Do we need a #make_ivar(data, &yld) method to make data into
    # instance variables for some templates like this one?
    def render_html(params={}, &yld)
      text = params[:text]
      file = params[:file]
      data = params[:data]

      data = make_hash(data, &yld)
      builder = ::Builder::XmlMarkup.new(engine_options(params))
      data.each{ |k,v| builder.instance_eval("@#{k} = v") }
      builder.instance_eval(text, file)
    end

    private

    # Load Erector library if not already loaded.
    def initialize_engine
      return if defined? ::Builder
      require_library 'builder'
    end

    # :target=>target_object: Object receiving the markup. target_object must
    # respond to the <<(a_string) operator and return itself.
    # The default target is a plain string target.
    #
    # :indent=>indentation: Number of spaces used for indentation. The default
    # is no indentation and no line breaks.
    #
    # :margin=>initial_indentation_level: Amount of initial indentation
    # (specified in levels, not spaces). 
    def engine_options(params)
      target = params[:target] || settings[:target]
      indent = params[:indent] || settings[:indent]
      margin = params[:margin] || settings[:margin]
      opts = {}
      opts[:target] = target if target
      opts[:indent] = indent if indent
      opts[:margin] = margin if margin
      opts
    end

  end

end

