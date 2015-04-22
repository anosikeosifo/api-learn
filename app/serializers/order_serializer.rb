class OrderSerializer < ActiveModel::Serializer

  cached

  attributes :id, :total
  has_many :products, serializer: OrderProductSerializer

  def cached_key
    [object, scope]
  end
end
