require "response_decorator/version"
require "response_decorator/decorator"
require "response_decorator/paginate_helper"
require "response_decorator/response_helper"
require "response_decorator/serializers_helper"

module ResponseDecorator
  module Methods
    def decorate(opts = {})
      Decorator.new(opts)
    end
  end
end
