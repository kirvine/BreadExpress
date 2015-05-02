class CartController < ApplicationController
  include BreadExpressHelpers::Cart

  def index
    @items_in_cart = get_list_of_items_in_cart
  end
end