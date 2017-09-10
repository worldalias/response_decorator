require "response_decorator/version"
require "response_decorator/base_serializer"
require "response_decorator/decorator"
require "response_decorator/paginate"

module ResponseDecorator
  module Helpers
    def decorate(opts = {})
      Decorator.new(opts)
    end

    def serialize(obj, options = {}, &block)
      if obj.is_a?(Array)
        headers 'X-PAGINATE' => paginate_attributes(obj).to_json
      end
      Decorator.new(resource: obj, scope: current_ability).serialize
    end

    def serialize_and_response(object, &block)
      object = yield(object) if block_given?
      # POST =>
      if request.post?
        if !object.errors.any?
          status 201
          serialize object
        else
          headers 'X-ERRORS' => object.errors.to_json
          status 500
        end
      # GET =>
      elsif request.get?
        if object
          status 200
          serialize object
        else
          status 404
        end
      # PUT/PATCH =>
      elsif request.put? || request.patch?
        if !object.errors.any?
          status 200
          serialize object
        else
          headers 'X-ERRORS' => object.errors.to_json
          status 404
        end
      # DELETE =>
      elsif request.delete?
        status(object ? 204 : 404)
      end
    end
  end
end
