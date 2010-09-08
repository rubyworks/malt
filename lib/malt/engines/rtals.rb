require 'malt/engines/abstract'

module Malt::Engines

  # RTALS
  #
  #  http://github.com/rubyworks/rtals
  #
  class RTALS < Abstract

    default :rtal

    #
    def render(params, &yld)
      text   = params[:text]
      file   = params[:file]
      data   = params[:data]
      format = params[:format]

      case format
      when :html, :xml, nil
        data = make_binding(data, &yld)
        intermediate(params).compile(data).to_s
      else
        super(params, &yld)
      end
    end

    #
    def intermediate(params)
      text = params[:text]
      ::RTAL.new(text)
    end

    private

    # Load Haml library if not already loaded.
    def initialize_engine
      return if defined? ::RTAL
      require_library 'rtals'
    end

  end

end

