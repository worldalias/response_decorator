require "response_decorator/version"

module ResponseDecorator
  class Decorator
    attr_reader :root, :serializer, :opts, :resource, :scope

    def initialize(opts = {})
      @opts = opts
      @scope = opts.delete(:scope)
      @resource = opts.delete(:resource)
      @root = detect_root
      @serializer = (opts[:serializer].is_a?(String) ? opts[:serializer].constantize : opts[:serializer]) || detect_serializer
    end

    def serialize
      if resource.respond_to?(:map)
        if serializer
          if root.present?
            { root.pluralize => resource.map{|r| { root => serializer.new(r, scope: @scope) } } }.to_json
          else
            resource.map{|r| serializer.new(r, scope: @scope) }.to_json
          end
        else
          if root.present?
            { root.pluralize => resource.map{|r| { root => r } } }.to_json
          else
            resource.to_json
          end
        end
      else
        if serializer
          if root.present?
            { root => serializer.new(resource, scope: @scope) }.to_json
          else
            serializer.new(resource, scope: @scope).to_json
          end
        else
          if root.present?
            { root => resource }.to_json
          else
            resource.to_json
          end
        end
      end
    end

    private
      def detect_object_class
        if defined?(Mongoid) && resource.is_a?(Mongoid::Criteria)
          resource.first.class.name
        elsif defined?(ActiveRecord) && resource.is_a?(ActiveRecord::Relation)
          if resource.first.nil?
            resource.name
          else
            resource.first.class.name
          end
        elsif defined?(ElasticRansack) && resource.is_a?(ElasticRansack::Search)
          if resource.first.nil?
            resource.model.name
          else
            if resource.first.is_a?(Tire::Results::Item)
              resource.first.type.classify
            else
              resource.first.class.name
            end
          end
        elsif defined?(Tire) && defined?(Tire::Results) && resource.is_a?(Tire::Results::Item)
          resource.type.classify
        elsif defined?("#{resource.class.name.singularize}Serializer".constantize)
          resource.class.name
        end
      end

      def detect_root
        if opts[:root].is_a?(TrueClass) || opts[:root].nil?
          detect_object_class != 'NilClass' ? detect_object_class.underscore.singularize : false
        elsif !opts[:root].nil?
          opts[:root]
        end
      end

      def detect_serializer
        if detect_object_class != 'NilClass' && defined?("#{detect_object_class}Serializer".constantize)
          "#{detect_object_class}Serializer".constantize
        end
      end
  end
end
