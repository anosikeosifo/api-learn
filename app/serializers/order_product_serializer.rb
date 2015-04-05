class OrderProductSerializer < ProductSerializer
  #this removes the embedded user
  def include_user?
    false
  end
end
