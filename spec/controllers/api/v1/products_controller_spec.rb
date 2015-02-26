require 'rails_helper'

describe Api::V1::ProductsController do

	describe "GET #show" do
		before(:each) do
			@product = FactoryGirl.create :product
			get :show, id: @product.id #this does the actual get request to the show action
		end


		it "returns a product's information on a hash" do
			product_response = json_response #this is the result returnd by the http request
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

		it { should respond_with 200 }
	end


	describe "POST #create" do

		context "when product is successfully created" do
			before(:each) do
				user = FactoryGirl.create :user
				@product_attr = FactoryGirl.attributes_for :product #to get random attr for an object, just use object.attributes_for
				api_authorization_header user.auth_token

				post :create, { user_id: user.id, product: @product_attr }
			end


			it "should respond with a json of the record just created" do
				products_response = json_response
				expect(products_response[:title]).to eql @product_attr[:title]
			end

			it { should respond_with 201 } #http code for creation successful
		end

		context "when product creation fails" do
			before(:each) do
				user = FactoryGirl.create :user
				@invalid_product_attr = { title:"wrong product title", price:"invalid price" }
				api_authorization_header user.auth_token

				post :create, { user_id: user.id, product: @invalid_product_attr }
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


	describe "PUT/PATCH #update" do
		before(:each) do
			@user = FactoryGirl.create :user
			@product = FactoryGirl.create :product, user: @user
			api_authorization_header @user.auth_token
		end

		context "Product details update successful" do
			before(:each) do
				patch :update, { id: @product.id, user_id: @user.id, product: { title: "Newly updated title"}} 
			end

			it "renders the json representation for the updated product" do
				products_response = json_response
				expect(products_response[:title]).to eql "Newly updated title"
			end

			it { should respond_with 200 } #success code
		end

		context "Product update fails" do
			before(:each) do
				patch :update, {id: @product.id, user_id: @user.id, product: { price:" invlaid price" }}
			end

			it "renders a result containing an error" do
				product_response = json_response
				expect(product_response).to have_key(:errors)
			end

			it { should respond_with 422 } #unprocessable entity
		end
	end

	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			@product = FactoryGirl.create :product, user: @user

			api_authorization_header @user.auth_token

			delete :destroy, {user_id: @user.id, id: @product.id}
		end

		# it "should delete product successfully" do
		# 	product_response = json_response
		# end

		it { should respond_with 204 }
	end
	
end