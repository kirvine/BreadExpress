class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	render layout: "home"
  end

  def baking
    @bread = create_baking_list_for("bread")
    @muffins = create_baking_list_for("muffins")
    @pastries = create_baking_list_for("pastries")
  end

  def about
    render layout: "application"
  end

  def privacy
    render layout: "application"
  end

  def contact
    render layout: "application"
  end
end