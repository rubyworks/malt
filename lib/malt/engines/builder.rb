require 'malt/engines/abstract'

module Malt::Engine

  # Builder
  #
  #   http://builder.rubyforge.org/
  #
  class Builder < Abstract

    default :builder

    #
    def render(params, &yld)
      into = parameters(params, :to)

      case into
      when :xml, :xhtml, nil
        render_xml(params, &yld)
      when :html, nil
        # @todo htmlify xml
        render_xml(params, &yld)
      else
        super(params, &yld)
      end
    end

    # TODO: Do we need a #make_ivar(data, &yld) method to make data into
    # instance variables for some templates like this one?

    #
    def render_xml(params={}, &yld)
      text, file, data = parameters(params, :text, :file, :data)

      data = make_hash(data, &yld)

      builder = intermediate(params)

      data.each{ |k,v| builder.instance_eval("@#{k} = v") }

      builder.instance_eval(text, file)
    end

    #
    def intermediate(params)
      ::Builder::XmlMarkup.new(engine_options(params))
    end

    private

    # Load Builder library if not already loaded.
    def initialize_engine
      return if defined? ::Builder
      require_library 'builder'
    end

    #
    # :target=>target_object: Object receiving the markup. target_object must
    # respond to the <<(a_string) operator and return itself.
    # The default target is a plain string target.
    #
    # :indent=>indentation: Number of spaces used for indentation. The default
    # is no indentation and no line breaks.
    #
    # :margin=>initial_indentation_level: Amount of initial indentation
    # (specified in levels, not spaces). 
    #
    def engine_option_names
      [:target, :indent, :margin]
    end

  end

end

