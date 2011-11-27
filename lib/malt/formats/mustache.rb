require 'malt/formats/abstract_template'
require 'malt/engines/mustache'

module Malt::Format
 
  # Mustache templates
  #
  #   http://github.com/defunkt/mustache
  #
  class Mustache < AbstractTemplate

    file_extension 'mustache'

    #
    def mustache(*)
      text
    end

    #
    def to_mustache(*)
      self
    end

    #private

    #
    #def render_engine
    #  @render_engine ||= Malt::Engine::Mustache.new(options)
    #end

  end

end

