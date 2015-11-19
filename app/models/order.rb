class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  PAYMENT_TYPES= %w(現金 クレジットカード 注文書)
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_line_items_from_cart(cart)
    cart.line_items.each{|item|
      item.cart_id=nil
      line_items<<item} #←item.order_id=idと同じようなもの
  end
  def total_price
    line_items.to_a.sum{|item|item.total_price}
  end
end
