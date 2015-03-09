require 'rails_helper'

describe Product do
  let(:product) { FactoryGirl.build :product }
  subject { product }

  it { should respond_to(:price) }
  it { should respond_to(:title) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  #by default, no item should be published
  it { should_not be_published }

  #validations test
  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:user_id) }


  #test association
  it { should belong_to :user }



  describe ".filter_by_title" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "First Product"
      @product2 = FactoryGirl.create :product, title: "Second Product"
      @product3 = FactoryGirl.create :product, title: "Third Product"
      @product4 = FactoryGirl.create :product, title: "The First Product"
    end

    context "when 'First' title pattern is sent" do

      it "returns the the matching products" do
        expect(Product.filter_by_title("First").sort).to match_array([@product1, @product4])
      end
      
    end
  end

  describe ".filter_by_title" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "First Product"
      @product2 = FactoryGirl.create :product, title: "Second Product"
      @product3 = FactoryGirl.create :product, title: "Third Product"
      @product4 = FactoryGirl.create :product, title: "The First Product"
    end

    context "when 'First' title pattern is sent" do

      it "returns the the matching products" do
        expect(Product.filter_by_title("First").sort).to match_array([@product1, @product4])
      end
      
    end
  end

  describe ".above_or_equal_to_price" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "First Product", price: 100
      @product2 = FactoryGirl.create :product, title: "Second Product", price: 200
      @product3 = FactoryGirl.create :product, title: "Third Product", price: 400
      @product4 = FactoryGirl.create :product, title: "The First Product", price: 250
    end

    context "when i search with 200 as price" do
      it "returns products equal or above the search price" do
        expect(Product.above_or_equal_to_price(200).sort).to match_array([@product2, @product3, @product4])
      end
    end
  end

  #notice the dots(.) used in model methods and the hash '#' used  to rep controller actions
  describe ".less_than_or_equal_price" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "First Product", price: 100
      @product2 = FactoryGirl.create :product, title: "Second Product", price: 200
      @product3 = FactoryGirl.create :product, title: "Third Product", price: 400
    end

    it "should return products whose price are less than 300" do
      expect(Product.less_than_or_equal_price(300).sort).to match_array([@product1, @product2])
    end
  end

  describe ".recent" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "First Product", price: 100
      @product2 = FactoryGirl.create :product, title: "Second Product", price: 200
      @product3 = FactoryGirl.create :product, title: "Third Product", price: 400
      @product4 = FactoryGirl.create :product, title: "Fourth Product", price: 700
      
      #calling touch updates the record
      @product2.touch
      @product4.touch
    end

    it "should render a list of recently updated products by date" do
      expect(Product.recent).to match_array([@product4, @product2, @product1, @product3])
    end
  end

  describe ".search" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "First Product", price: 100
      @product2 = FactoryGirl.create :product, title: "Second Product", price: 200
      @product3 = FactoryGirl.create :product, title: "Third Product", price: 400
      @product4 = FactoryGirl.create :product, title: "Fourth Product", price: 700  
    end

    context "when i search with a non-existent keyword" do
      it "should return an empty array" do
        search_hash = { keyword: "last" }
        expect(Product.search(search_hash)).to be_empty
      end
    end

    context "when i search with keyword: 'first'" do
      it "should return an empty array" do
        search_hash = { keyword: "first"}
        expect(Product.search(search_hash)).to match_array([@product1])
      end
    end

    context "when i search with max price: '200'" do
      it "should return appropriate array" do
        search_hash = { max_price: 200 }
        expect(Product.search(search_hash)).to match_array([@product1, @product2])
      end
    end

    context "when i search with min price: '200'" do
      it "should return an empty array" do
        search_hash = { min_price: 200 }
        expect(Product.search(search_hash)).to match_array([@product2, @product3, @product4])
      end
    end

    context "when i search with an empty hash" do
      it "should return all products" do
        expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4])
      end
    end
  end
end
