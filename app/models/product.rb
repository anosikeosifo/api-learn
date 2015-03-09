class Product < ActiveRecord::Base
	validates :title, :user_id, presence: true
	validates :price, 
		numericality: { greater_than_or_equal_to: 0 }, presence: true

	belongs_to :user

	scope :filter_by_title, lambda { |keyword|
		where("lower(title) LIKE ?", "%#{keyword.downcase}%")
	}

	scope :above_or_equal_to_price, lambda { |price| 
		where("price >= ?", price)
	}

	scope :less_than_or_equal_price, lambda { |price|
		where("price <= ?", price)
	}

	scope :recent, lambda{ order(:updated_at) }

	def self.search(params = {})
		products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all

		products = Product.filter_by_title(params[:keyword]) if params[:keyword].present?

		products = Product.above_or_equal_to_price(params[:min_price]) if params[:min_price].present?

		products = Product.less_than_or_equal_price(params[:max_price]) if params[:max_price].present?
		
		products = Product.recent(params[:recent]) if params[:recent].present?
	
		products
	end
end
