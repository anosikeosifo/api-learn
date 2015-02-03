require 'rails_helper'

describe Api::V1::ProductsController do

	describe "GET #show" do
		before(:each) do
			@product = FactoryGirl.create :product
			get :show, id: @product.id
		end


		it "returns a product's information on a hash" do
			product_response = json_response
			expect(product_response[:title]).to eql @product.title
		end

		it { should respond_with 200 }
	end

	describe "GET #index" do
		before(:each) do
			4.times { FactoryGirl.create :product }
			get :index #note here that i dont need additional url params
		end

		it "should return the list (count: 4) of products" do
			product_response = json_response
			expect(product_response[:products]).to have(4).items
		end
	end


	describe "POST #create" do
		before(:each) do

		end

		context "when product is successfully created" do
			before(:each) do
				user = FactoryGirl.create :user
				@product_attr = FactoryGirl.attributes_for :product
				api_authorization_header user.auth_token

				post :create, { user_id: user.id, product: @product_attr }
			end


			it "should respond with a json of the record just created" do
				products_response = json_response
				expect(json_response[:title]).to eql @product_attr[:title]
			end

			it { should respond_with 201 } #http code for creation successful
		end

		context "when product creation fails" do
			before(:each) do
				user = FactoryGirl.create :user
				@invalid_product_attr = { title:"wrong product title", price:"invalid price" }
				api_authorization_header user.auth_token

				post :create, { user_id: user.id, product: @product_attr }
			end

			it "should contain an error response" do
				product_response = json_response
				expect(product_response).to have_key(:errors)
			end

			it "should contain appropriate error messages" do
				product_response = json_response
				expect(product_response[:errors][:price]).to include "is not a number"
			end

			it { should respond_with 422 } #unproccessable entity
		end
	end
	
end