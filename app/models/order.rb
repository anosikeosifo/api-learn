class Order < ActiveRecord::Base
  
  before_validation :set_total!

  # validates :total, presence: true, numericality: {greater_than_or_equal_to: 0 }
  validates :user_id, presence: true

  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  def set_total!
    self.total = products.map(&:price).sum
    # products.reduce(&+:price)
  end

  def build_placements_with_product_ids_and_quantity(product_ids_and_quantties) 
    product_ids_and_quantties.each do |product_id_and_qty|
      id, quantity = product_id_and_qty

      self.placements.build(product_id: id, quantity: quantity) #build a placement abd tie it to and order and product_id
    end
  end
end
