require 'rails_helper'
# require 'spec_helper'

describe User do
	before { @user = FactoryGirl.build(:user) }

	subject { @user }

	it	{ should respond_to(:email) }
	it	{ should respond_to(:password) }
	it	{ should respond_to(:password_confirmation) }

	it	{ should be_valid }
end

# RSpec.describe User, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end