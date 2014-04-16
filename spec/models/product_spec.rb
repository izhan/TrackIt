require 'spec_helper'

describe Product do
  it { should respond_to(:url) }
  it { should respond_to(:api) }
  it { should respond_to(:current_price) }
  it { should respond_to(:name) }
  it { should respond_to(:thumbnail) }

  describe "validates url", api: true do
    before do
      @product = Product.new()
    end
    it "should be valid for valid urls" do
      @product.url = "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p?id=1219034548328&skuId=9638372&st=categoryid$abcat0706002&lp=2&cp=1"
      expect(@product).to be_valid
    end
    it "should be invalid for non urls" do
      @product.url = "asdf123"
      expect(@product).not_to be_valid
    end
  end

  # IN TEST ENVIRONMENT ONLY -- should comment out unless you get 403
  # describe "throttling APIs" do
  #   describe "for Best Buy API" do
  #     before do
  #       @product_list = []
  #       25.times do |i|
  #         @product = Product.new(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p?id=1219034548328&skuId=9638372&st=categoryid$abcat0706002&lp=2&cp=1")
  #         @product.save
  #         @product_list << @product
  #       end
  #     end
  #     it "should work" do
  #       1.should == 1
  #     end
  #   end
  # end

  # Testing API
  describe "for testing api" do
    describe "for any example url" do
      before do
        @product = Product.create(url: "www.example.com/asdf123")
        @product.save
      end

      it "should have right params" do
        @product.valid?.should == true
        @product.api.should == "example"
        @product.current_price.should == 100
        @product.name.should ==  "example.com/asdf123"
      end

      describe "when modified" do
        before do
          @product.name = "Something Else"
          @product.current_price = 1
          @product.save
        end
        it "should be abled to be saved" do
          @product.valid?.should == true
          @product.name.should == "Something Else"
          @product.current_price.should == 1
        end
      end
    end
  end

  ## USES BEST BUY API for now.  replace later
  describe "should be able to create a new obj with just url", api: true, bestbuy: true do
    before do
      @product = Product.new(url: "http://www.bestbuy.com/site/masticating-juicer/1614687.p?id=1219057246863&skuId=1614687&st=categoryid$pcmcat194000050019&cp=1&lp=8")
      @product.save
    end

    it "should parse the url and gather right info about product" do
      @product.url.should ==  "bestbuy.com/site/masticating-juicer/1614687.p"
      @product.api.should ==  "bestbuy"
      @product.current_price.should ==  25999
      @product.name.should ==  "Omega - Masticating Juicer - Chrome"
    end

    describe "when similar urls are passed in" do
      before do
        @product2 = Product.new(url: "bestBUY.com/site/masticating-juicer/1614687.p?id=123")
      end

      it "should not create a new product" do
        @product.valid?.should == true
        expect { @product2.save }.to_not change(Product, :count).by(1)
      end
    end
  end
end
