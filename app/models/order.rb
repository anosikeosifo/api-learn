class Order < ActiveRecord::Base
  
  before_validation :set_total!

  # validates :total, presence: true, numericality: {greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates_with EnoughProductsValidator

  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  def set_total!
    self.total = 0
    placements.each do |placement|
      self.total += placement.product.price * placement.quantity
    end
    self.total
  end

  def build_placements_with_product_ids_and_quantity(product_ids_and_quantties) 
    product_ids_and_quantties.each do |product_id_and_qty|
      id, quantity = product_id_and_qty

      self.placements.build(product_id: id, quantity: quantity) #build a placement abd tie it to and order and product_id
    end
  end
end
