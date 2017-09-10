module ResponseDecorator
  module SerializersHelper
    def serialize(obj, options = {}, &block)
      if obj.is_a?(Array)
        headers 'X-PAGINATE' => paginate_attributes(obj).to_json
      end
      Decorator.new(resource: obj, scope: current_ability).serialize
      # json obj, scope: current_ability
    end
  end
end
