class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	render layout: "home"
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