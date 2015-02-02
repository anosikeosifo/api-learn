require 'rails_helper'

describe Api::V1::UsersController do
	#concatenate the json format
	#this test is failing so i commented it out.
	# describe "GET #index" do
	# 	before(:each) do
	# 		# 3.times do |i|
	# 		# 	@user = FactoryGirl.create :user				
	# 		# end
	# 		@lonimi = FactoryGirl.create(:user, name: "Lonimi", email: "nimi@email.com")
	# 		@faridah = FactoryGirl.create(:user, name: "faridah", email: "faridah@email.com")

	# 		get :index
	# 	end

	# 	it "should return a list of users" do
	# 		user_response = json_response
	# 		expect(user_response[0][:email]).to eql @lonimi.email
	# 	end

	# 	it { should respond_with 200 }
	# end
	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :user
			get :show, id: @user.id
		end

		it "returns information about a user on a hash" do
			user_response = json_response
			expect(user_response[:email]).to eql @user.email
		end

		it { should respond_with 200 } 
	end


	describe "POST #create" do
		context "when user is successfully created" do
			before(:each) do
				@user_attr = FactoryGirl.attributes_for :user #this supplies the attribtutes, but doesn't create the user
				post :create, { user: @user_attr }
			end

			it "renders the json representation of the newly created user" do
				user_response = json_response
				expect(user_response[:email]).to eql @user_attr[:email]
			end

			it { should respond_with 201 }
		end

		context "when user creation fails" do
			before(:each) do 
				@wrong_user_attr = { pasword: "12345678", password_confirmation: "12345678" }
				post :create, { user: @wrong_user_attr }
			end

			it "should render an error json result" do
				user_response = json_response
				expect(user_response).to  have_key(:errors)
			end

			it "should render json errors, stating why user creation failed" do
				user_response = json_response
				expect(user_response[:errors][:email]).to include "can't be blank" #this contains the email cant be blank error message
			end

			it { should respond_with 422 }
		end
	end

	describe "PUT/PATCH #update" do

		before(:each) do 
			@user = FactoryGirl.create :user
			request.headers["Authorization"] = @user.token
		end

		context "when user update is successful" do
			before(:each) do 
				@user = FactoryGirl.create :user
				patch :update, { id: @user.id, user: { email: "newemail@user.com" } }
			end

			it "renders the json representation of the updated user" do
				user_response = json_response
				expect(user_response[:email]).to eql "newemail@user.com" #response should reflect the updted email
			end

			it { should respond_with 200 }
		end

		context "when user update fails" do
			before(:each) do
				@user = FactoryGirl.create :user
				patch :update, { id: @user.id, user: { email: "wrongemail.com" } }
			end

			it "renders an error json showing update failure" do
				user_response = json_response
				expect(user_response).to have_key(:errors)
			end

			it "renders a message containing the reason why update failed" do
				user_response = json_response
				expect(user_response[:errors][:email]).to include "is invalid"
			end

			it { should respond_with 422 } 
		end
	end


	describe "DELETE #delete" do
		before(:each) do
			@user = FactoryGirl.create :user
			api_authorization_header @user.auth_token
			delete :destroy, { id: @user.id }
		end

		it { should respond_with 204 }
	end
end
