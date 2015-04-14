require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do

  describe "GET #index" do
    before(:each) do
      current_user  = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }

      get :index, user_id: current_user.id
    end

    it "returns 4 order records by the current user" do
      orders_response = json_response[:orders]
      expect(orders_response.size).to eq(4)
    end

    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }
    
    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user;
      api_authorization_header current_user.auth_token
      @order = FactoryGirl.create :order, user: current_user

      get :show, user_id: current_user.id, id: @order.id
    end

    it "returns the order details" do
      order_response = json_response[:order]
      expect(order_response[:id]).to eql @order.id
    end

    it { should respond_with 200 }

    it "includes the total for the order" do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql @order.total.to_s
    end

  end

  describe "POST #create" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      product_a = FactoryGirl.create :product
      product_b = FactoryGirl.create :product

      order_params = { product_ids_with_qty: [[product_a.id, 2], [product_b.id, 3]] }
      post :create, user_id: current_user.id, order: order_params 
    end

    it "returns the just-created order" do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present #this is a proof of order creation
    end

    it { should respond_with 201 }
  end

end
