class ProductSerializer < ActiveModel::Serializer
  cached
  
  attributes :id, :title, :price, :published
  has_one :user #this creates the association between the user and product. allowing for a nested response

  def cache_key
    [object, scope]
  end
end