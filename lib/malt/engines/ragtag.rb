require 'malt/engines/abstract'

module Malt::Engine

  # RagTag
  #
  #  http://github.com/rubyworks/ragtag
  #
  class RagTag < Abstract

    default :ragtag, :rt

    #
    def render(params, &yld)
      text = params[:text]
      file = params[:file]
      data = params[:data]
      into = params[:to]

      case into
      when :html, nil
        binding = make_binding(data, &yld)
        intermediate(params).compile(binding).to_xhtml
      when :xml
        binding = make_binding(data, &yld)
        intermediate(params).compile(binding).to_xml
      else
        super(params, &yld)
      end
    end

    #
    def intermediate(params)
      text = params[:text]
      ::RagTag.new(text)
    end

    private

    # Load Haml library if not already loaded.
    def initialize_engine
      return if defined? ::RagTag
      require_library 'ragtag'
    end

  end

end

