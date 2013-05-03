require 'decent_exposure/constant_resolver'
require 'active_support/inflector'
require 'active_support/core_ext/string'

module DecentExposure
  class Inflector
    attr_reader :string, :original, :model
    alias name string

    def initialize(name, model=nil)
      @original = name.to_s
      @model = model
      @string = (model || name).to_s.demodulize.downcase
    end

    def constant(context=Object)
      case model
      when Module, Class
        model
      else
        ConstantResolver.new(string, context).constant
      end
    end

    def parameter
      singular + "_id"
    end

    def singular
      @singular ||= string.singularize.parameterize
    end

    def plural
      string.pluralize
    end
    alias collection plural

    def plural?
      original.pluralize == original && !uncountable?
    end

    def uncountable?
      original.pluralize == original.singularize
    end
  end
end
