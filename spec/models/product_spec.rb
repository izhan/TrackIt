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
        @product.name.should ==  "Testing API Item 1"
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

  # BEST BUY
  describe "for best buy api" do
    describe "for invalid url" do
      before do
        @product = Product.new(url: "http://www.bestbuy.com/asdf123")
      end

      it "should not save" do
        expect { @product.save }.to_not change(Product, :count).by(1)
      end
    end

    describe "for valid url" do
      before do
        @product = Product.new(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p?id=1219034548328&skuId=9638372&st=categoryid$abcat0706002&lp=2&cp=1")
        @product.save
        sleep(1)
      end

      it "should parse the url and gather right info about product" do
        @product.url.should ==  "bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p"
        @product.api.should ==  "bestbuy"
        @product.current_price.should ==  3999
        @product.name.should ==  "Just Dance 2014 - Nintendo Wii"
      end

      describe "when modified" do
        before do
          @product.name = "Potato"
          @product.save
        end
        it "should not be able to be modified (consistency among users)" do
          @product.name.should ==  "Just Dance 2014 - Nintendo Wii"
        end
      end
    end

    describe "for input with whitespaces" do
      before do
        @product = Product.new(url: "http://www.bestbuy.com/site/in-search-of-history-potions-or-poisons-dvd/18542268.p?id=2103562&skuId=18542278&st=Search%20by%20Keyword,%20SKU%20# or Item #&lp=1&cp=1")
        @product.save
        sleep(1)
      end
      it "should ignore them" do
        @product.url.should ==  "bestbuy.com/site/in-search-of-history-potions-or-poisons-dvd/18542268.p"
        @product.api.should ==  "bestbuy"
        @product.current_price.should ==  1999
        @product.name.should ==  "In Search of History: Potions or Poisons? (DVD)"
      end
    end

    describe "for invalid url" do
      describe "invalid SKUID number" do
        before do
          @product = Product.create(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/1234567.p")
        end

        it "should not be created and display error" do
          expect { @product.save }.to_not change(Product, :count).by(1)
        end
      end
      describe "no skuid number" do
        before do
          @product = Product.create(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/something")
        end

        it "should not be created and display error" do
          expect { @product.save }.to_not change(Product, :count).by(1)
        end
      end
      describe "improperly formatted skuid" do
        before do
          @product = Product.create(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/123.p")
        end

        it "should not be created and display error" do
          expect { @product.save }.to_not change(Product, :count).by(1)
        end
      end
    end
  end

  ## USES BEST BUY API for now.  replace later
  describe "should be able to create a new obj with just url" do
    before do
      @product = Product.new(url: "http://www.bestbuy.com/site/masticating-juicer/1614687.p?id=1219057246863&skuId=1614687&st=categoryid$pcmcat194000050019&cp=1&lp=8")
      @product.save
      sleep(1)
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
