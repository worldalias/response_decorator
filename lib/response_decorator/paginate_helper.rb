module ResponseDecorator
  module PaginateHelper
    def paginate_attributes(collection)
      {
        limit:  limit,
        offset: offset,
        total:  collection.count
      }
    end

    # Returns {Integer} of items per page based on params[:limit] or
    # PER_PAGE const.
    def limit
      limit_params   = params[:limit].to_i
      ( limit_params > 0 ? limit_params : settings.limit_on_page )
    end

    # Returns {Integer} as number of records to skip, taken from params[:offset]
    # or 0 (by default)
    def offset
      params[:offset].to_i
    end
  end
end
