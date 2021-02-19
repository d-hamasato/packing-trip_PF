class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_items
    search_params = item_search_params
    if search_params[:only_myitem]
      @items = current_user.items.search(search_params)
    else
      @items = Item.public_items.search(search_params)
    end
  end

  def search_packings
    search_params = packing_search_params
    if search_params[:only_mypacking]
      @packings = current_user.packings.search(search_params)
    else
      @packings = Packing.public_packings.search(search_params)
    end
  end

  private

  def item_search_params
    params.fetch(:search, {}).permit(:word, :min_weight, :max_weight, :only_myitem, tag_ids: [])
  end

  def packing_search_params
    params.fetch(:search, {}).permit(:word, :selected_number_of_nights, :only_mypacking, tag_ids: [])
  end
end
