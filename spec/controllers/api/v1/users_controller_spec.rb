require 'rails_helper'

describe Api::V1::UsersController do
	before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :user
			get :show, id: @user.id, format: :json
		end

		it "returns information about a user on a hash" do
			user_response = JSON.parse(response.body, symbolize_names: true)
			expect(user_response[:email]).to eql @user.email
		end

		it { should respond_with 200 } 
	end


	describe "POST #create" do
		context "when user is successfully created" do
			before(:each) do
				@user_attr = FactoryGirl.attributes_for :user #this supplies the attribtutes, but doesn't create the user
				post :create, { user: @user_attr }, format: :json
			end

			it "renders the json representation of the newly created user" do
				user_response = JSON.parse(response.body, symbolize_names: true)
				expect(user_response[:email]).to eql @user_attr[:email]
			end

			it { should respond_with 201 }
		end

		context "when user creation fails" do
			before(:each) do 
				@wrong_user_attr = { pasword: "12345678", password_confirmation: "12345678" }
				post :create, { user: @wrong_user_attr }, format: :json
			end

			it "should render an error json result" do
				user_response = JSON.parse(response.body, symbolize_names: true)
				expect(user_response).to  have_key(:errors)
			end

			it "should render json errors, stating why user creation failed" do
				user_response = JSON.parse(response.body, symbolize_names: true)
				expect(user_response[:errors][:email]).to include "can't be blank" #this contains the email cant be blank error message
			end

			it { should respond_with 422 }
		end
	end


	
end
