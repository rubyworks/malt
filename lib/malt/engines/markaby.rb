require 'malt/engines/abstract'

module Malt::Engine

  # Markaby
  #
  # @see http://markaby.rubyforge.org/
  #
  # Markaby doesn't support template caching b/c the the initializer
  # takes the local variable settings.
  # 
  class Markaby < Abstract

    default  :markaby, :mab
    register :rbml, :builder

    #
    def render(params, &content)
      into = parameters(params, :to) || :html

      case into
      when :html, :xml, :xhtml
        prepare_engine(params, &content).to_s
      else
        super(params, &content)
      end
    end

    # TODO: Prefix support ?

    #
    def prepare_engine(params={}, &content)
      text, file, data, prefix = parameters(params, :text, :file, :data, :prefix)

      file = file || "(#{inspect})"

      if prefix
        raise NotImplmentedError, "Markaby doesn't support prefix templates."
        #scope, locals = scope_and_locals(data, &content)

        scope, locals = split_data(data)

        scope  ||= Object.new
        locals ||= {}

        mab = ::Markaby::Builder.new(locals) #, scope)

        code = %{
          lambda do |#{prefix}|
            #{text}
          end
        }

        eval(code, scope.to_binding, file).call(mab)
      else
        scope, locals = external_scope_and_locals(data, &content)

        mab = ::Markaby::Builder.new(locals, scope)
        mab.instance_eval(text, file)
        mab
      end
    end

  private

    # Load Markaby library if not already loaded.
    def require_engine
      return if defined? ::Markaby
      require_library 'markaby'
    end

  end

end
