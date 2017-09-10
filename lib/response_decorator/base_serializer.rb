module ResponseDecorator
  class BaseSerializer < ActiveModel::Serializer
    ACL_LIST = [ :list, :view, :create, :update, :delete ]
    attributes :id, :created_at, :updated_at, :meta

    # INFO: Need for return id like integer from ES
    def id
      object.id.to_i
    end

    def created_at
      object.created_at ? object.created_at.utc.try(:strftime, "%FT%T%:z") : nil
    end

    def updated_at
      object.updated_at ? object.updated_at.utc.try(:strftime, "%FT%T%:z") : nil
    end

    def meta
      { ability: ACL_LIST.select { |a| scope.can? a, object } } if scope
    end
  end
end
