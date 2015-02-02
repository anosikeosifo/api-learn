require 'rails_helper'
# require 'spec_helper'

describe User do
	before { @user = FactoryGirl.build(:user) }

	subject { @user }

	it	{ should respond_to(:email) }
	it	{ should respond_to(:password) }
	it	{ should respond_to(:password_confirmation) }

	#it should also respond to auth_token
	it { should respond_to(:auth_token) }

	it { should be_valid }
	it { should validate_presence_of(:email) }
	it { should validate_uniqueness_of(:email) }
	it { should validate_confirmation_of(:password) }
	it { should allow_value('example@domain.com').for(:email) }

	#auth_token should also be unique for users
	it { should validate_uniqueness_of(:auth_token) } 



	describe "#genetate_aunthentication_token" do
		it "generates a unique token" do
			Devise.stub(:friendly_token).and_return("osifo_unuque_token")
			@user.generate_auth_token!
			expect(@user.auth_token).to eql "osifo_unuque_token"
		end

		it "generates another token when one has already been taken" do
			existing_user = FactoryGirl.create(:user, auth_token: "token_in_use")

			@user.generate_auth_token!
			expect(@user.auth_token).not_to eql existing_user.auth_token #coz its already in use
		end

	end
end