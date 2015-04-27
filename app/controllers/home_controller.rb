class HomeController < ApplicationController
  include BreadExpressHelpers::Baking

  def home
  	render layout: "home"
  end

  def about
  end

  def privacy
  end

  def contact
  end






end