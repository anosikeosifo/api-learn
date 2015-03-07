require 'rails_helper'

describe Api::V1::SessionsController, :type => :controller do
	describe "POST #create" do
		before(:each) do
			@user = FactoryGirl.create :user
		end

		context "when the user credentials are correct" do
			before(:each) do 
				credentials = { email: @user.email, password: "12345678" }
				post :create, { session: credentials }
			end

			it "returns the user record associated with the passed credentials" do
				@user.reload
				expect(json_response[:user][:auth_token]).to eql @user.auth_token
			end

			it { should respond_with 200 }
		end


		context "when credentials passed are wrong" do
			before(:each) do 
				credentials = { email: @user.email, password: "thisisawrongpassword" }
				post :create, { session: credentials }
			end

			it "returns json with error" do
				expect(json_response[:errors]).to include "Invalid email or password"
			end


			it { should respond_with 422 }
		end
	end


	describe "DELETE #destroy" do
		before(:each) do
			@user = FactoryGirl.create :user
			sign_in @user #, store: false
			delete :destroy, id: @user.auth_token #this makse the http DELETE request
		end

		it { should respond_with 204 }  #httpCode item deleted
	end
end
