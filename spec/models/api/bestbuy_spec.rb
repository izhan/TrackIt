describe "for best buy api", api: true, bestbuy: true do
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
      @product = Product.new(url: "http://www.bestbuy.com/site/40-channel-compact-cb-radio/9044321.p?id=1218012121855&skuId=9044321&st=categoryid$abcat0302011&cp=1&lp=1")
      @product.save
    end

    it "should parse the url and gather right info about product" do
      @product.url.should ==  "bestbuy.com/site/40-channel-compact-cb-radio/5276086.p"
      @product.api.should ==  "bestbuy"
      #@product.current_price.should ==  6499
      @product.name.should ==  "Sony - PlayStation 3 Gaming Console"
    end

    # describe "when modified" do
    #   before do
    #     @product.name = "Potato"
    #     @product.save
    #   end
    #   it "should not be able to be modified (consistency among users)" do
    #     @product.name.should ==  "Uniden - 40-Channel Compact CB Radio - Black"
    #   end
    # end
  end

  describe "edge cases" do
    describe "strange url with semicolon" do
      before do
        @product = Product.create(url: "http://www.bestbuy.com/site/iphone-174-5-with-16gb-memory-mobile-phone/6699371.p;jsessionid=06971AD8EB18471BA8384C0969E3ACD6.bbolsp-app01-112?id=1218789786160")
      end

      it "should be created" do
        @product.url.should ==  "bestbuy.com/site/iphone-174-5-with-16gb-memory-mobile-phone/6699371.p;jsessionid=06971ad8eb18471ba8384c0969e3acd6.bbolsp-app01-112"
        @product.api.should ==  "bestbuy"
        @product.current_price.should ==  69999
        @product.name.should ==  "Apple® - iPhone® 5 with 16GB Memory Mobile Phone - White & Silver (AT&T)"
      end
    end
  end

  describe "for products on sale" do
    before do
      @product = Product.create(url: "http://www.bestbuy.com/site/aquos-q-series-80-class-80-diag--led-1080p-240hz-smart-3d-hdtv/3348009.p")
    end

    it "should be created" do
      @product.url.should ==  "bestbuy.com/site/aquos-q-series-80-class-80-diag--led-1080p-240hz-smart-3d-hdtv/3348009.p"
      @product.api.should ==  "bestbuy"
      #@product.current_price.should ==  499998
      @product.name.should ==  "Sharp - AQUOS Q+ Series - 80\" Class (80\" Diag.) - LED - 1080p - 240Hz - Smart - 3D - HDTV - Silver"
    end
  end

  describe "for input with whitespaces" do
    before do
      @product = Product.new(url: "http://www.bestbuy.com/site/in-search-of-history-potions-or-poisons-dvd/18542268.p?id=2103562&skuId=18542278&st=Search%20by%20Keyword,%20SKU%20# or Item #&lp=1&cp=1")
      @product.save
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