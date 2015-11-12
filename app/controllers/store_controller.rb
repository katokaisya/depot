class StoreController < ApplicationController
  def index
    @products=Product.order(:title).first(3)
  end
end
