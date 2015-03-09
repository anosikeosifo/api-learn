class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :published
  has_one :user #this creates the association between the user and product. allowing for a nested response
end