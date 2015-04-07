require 'rails_helper'

describe Order  do
  let(:order) { FactoryGirl.build :order }
  subject { order }

  it { should respond_to(:total) }
  it { should respond_to(:user_id) }

  it { should validate_presence_of :user_id }
  # it { should validate_presence_of :total }

  it { should belong_to :user }


  it { should have_many(:placements) }
  it { should have_many(:products).through(:placements) }


  describe "#set_total!" do
    before(:each) do
      product_1 = FactoryGirl.create :product, price: 100
      product_2 = FactoryGirl.create :product, price: 250

      @order = FactoryGirl.build :order, product_ids: [product_1.id, product_2.id]
    end

    it "returns the sum of product prices as order-total" do
      expect{ @order.set_total! }.to change{ @order.total }.from(0).to(350)
    end
  end

  describe "#build_placements_with_product_ids_and_quantity" do
    before(:each) do
      product_1 = FactoryGirl.create :product, quantity: 13
      product_2 = FactoryGirl.create :product, quantity: 4
      @product_ids_with_quantities = [[product_1.id, 3], [product_2.id, 34]]
    end

    it "builds two placements for the order" do
      expect{ order.build_placements_with_product_ids_and_quantity(@product_ids_with_quantities) }
      .to change{ order.placements.size }.from(0).to(2)
    end
  end
end

