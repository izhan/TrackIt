require 'spec_helper'

describe Product do
  it { should respond_to(:url) }
  it { should respond_to(:api) }
  it { should respond_to(:current_price) }
  it { should respond_to(:name) }
  it { should respond_to(:thumbnail) }

  describe "validates url" do
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

  # BEST BUY
  describe "for best buy api" do
    describe "for valid url" do
      before do
        @product = Product.new(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p?id=1219034548328&skuId=9638372&st=categoryid$abcat0706002&lp=2&cp=1")
        @product.save
      end

      it "should parse the url and gather right info about product" do
        @product.url.should ==  "bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p"
        @product.api.should ==  "bestbuy"
        @product.current_price.should ==  3999
        @product.name.should ==  "Just Dance 2014 - Nintendo Wii"
      end
    end

    describe "for invalid url" do
      describe "invalid SKUID number" do
        before do
          @product = Product.create(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/1234567.p")
        end

        it "should not be created and display error" do
          @product.valid?.should == false
        end
      end
      describe "no skuid number" do
        before do
          @product = Product.create(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/something")
        end

        it "should not be created and display error" do
          @product.valid?.should == false
        end
      end
      describe "improperly formatted skuid" do
        before do
          @product = Product.create(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/123.p")
        end

        it "should not be created and display error" do
          @product.valid?.should == false
        end
      end
    end
  end

  ## USES BEST BUY API for now.  replace later
  describe "should be able to create a new obj with just url" do
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
        expect { @product2.save }.to_not change(Product, :count).by(1)
      end
    end
  end
end
