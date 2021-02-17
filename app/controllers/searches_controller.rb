class SearchesController < ApplicationController
  def search_items
    search_word = params[:search_ward]
    tags = params[:tag_ids].reject(&:blank?)
    min_weight = params[:min_weight]
    max_weight = params[:max_weight]
    @items = Item.public_items.search_for(search_word, tags, min_weight, max_weight)
  end
end
