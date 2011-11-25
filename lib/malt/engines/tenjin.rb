require 'malt/engines/abstract'

module Malt::Engine

  # Tenjin
  #
  # @see http://www.kuwata-lab.com/tenjin/
  #
  # Let to it's own designs, Tenjin renders data as template instance variables.
  # But that will not work for Malt, so use regular variables instead.
  #
  class Tenjin < Abstract

    default :tenjin, :rbhtml

    # Render Tenjin.
    #
    # @option params [String] :escapefunc
    #   Defaults to 'CGI.escapeHTML'.
    #
    def render(params, &content)
      into, text, file, data, type = parameters(params, :to, :text, :file, :data, :type)

      into ||= :html

      if type == :rbhtml && into != :html
        super(params, &content) 
      else
        scope, locals = scope_and_locals(data, &content)
        engine = prepare_engine(params)
   
        engine.call(scope, locals)
      end
    end

    # TODO: is there a way to split this out to a #compile method?

    #
    def prepare_engine(params={}, &content)
      text, file = parameters(params, :text, :file)

      file ||= "(tenjin)"

      engine = create_engine(params)
      script = engine.convert(text, file)

      lambda do |scope, locals|
        vars, vals = [], []
        locals.each do |k,v|
          vars << k
          vals << v
        end

        code = %{
          lambda do |#{vars.join(',')}|
            _buf = ''
            #{script}
            _buf
          end
        }

        eval(code, scope.to_binding, file, 2).call(*vals)
      end
    end

    #
    def create_engine(params={})
      file, text = parameters(params, :file, :text)

      opts = engine_options(params)

      opts[:escapefunc] ||= 'CGI.escapeHTML'

      cached(text, file, opts) do
        ::Tenjin::Template.new(nil, opts)
      end
    end

    # Compile Tenjin document into Ruby source code.
    #def compile(params)
    #  text, file = parameters(params, :text, :file)
    #  code = intermediate(params).convert(text, file)
    #  "_buf = ''\n#{code}\n_buf"
    #end

  private

    # Load Tenjin library if not already loaded.
    def require_engine
      return if defined? ::Tenjin::Engine
      require_library 'tenjin'
      require 'cgi'
    end

    #
    def engine_option_names
      [:escapefunc]
    end

  end

end

