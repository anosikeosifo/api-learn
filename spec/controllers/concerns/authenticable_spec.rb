require 'rails_helper'


class Authentication
	include Authenticable
end


describe Authenticable do
	let(:authentication) { Authentication.new }

	describe "#current_user" do
		before do
			@user = FactoryGirl.create :user
			request.headers["Authorization"] = @user.auth_token
			authentication.stub(:request).and_return(request)
		end

		it "returns the user from the Authorization header" do
			expect(authentication.current_user.auth_token).to eql @user.auth_token 
		end
	end

	describe "#authenticate_with_token" do
		before do
			@user = FactoryGirl.create :user
			authentication.stub(:current_user).and_return(nil)
			response.stub(:response_code).and_return(401)
			response.stub(:body).and_return({ "errors" => "Not Authenticated" })
			authentication.stub(:response).and_return(response)
		end

		it "should render a json error message" do
			expect(json_response[:errors]).to include "Not Authenticated"
		end
	end
end