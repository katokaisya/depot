class StoreController < ApplicationController

  def index
    @products=Product.order(:title).first(5)
  end
end
