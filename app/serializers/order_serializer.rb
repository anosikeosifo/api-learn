class OrderSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :user

end
