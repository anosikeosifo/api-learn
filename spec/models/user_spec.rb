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


	#test association
	it { should have_many(:products) }
	it { should have_many(:orders) }



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

	describe "product association" do
		before do
			@user.save
			#creates products and ties it to same user
			3.times { FactoryGirl.create :product, user: @user } 
		end

		it "destroys associated products on self destruct" do
			products = @user.products
			@user.destroy #attempts destroying the user
			
			products.each do |product|
				expect(Product.find(product)).to raise_error ActiveRecordNotFound
			end
		end
	end

end