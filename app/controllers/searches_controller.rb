class SearchesController < ApplicationController
  def search_items
    search_params = item_search_params
    if search_params[:only_myitem]
      @items = current_user.items.search(search_params)
    else
      @items = Item.public_items.search(search_params)
    end
  end

  private

  def item_search_params
    params.fetch(:search, {}).permit(:word, :min_weight, :max_weight, :only_myitem, tag_ids: [])
  end
end
