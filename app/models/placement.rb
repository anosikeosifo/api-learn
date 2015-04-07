class Placement < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  #after every placement creation, decrement the product qty
  after_create :decrement_product_quantity!

  def decrement_product_quantity!
    self.product.decrement!(:quantity, quantity)
  end
end
