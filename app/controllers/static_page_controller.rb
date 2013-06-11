class StaticPageController < ApplicationController
  def index
  	@users = User.all
  end
end
