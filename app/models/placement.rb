class Placement < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
end
