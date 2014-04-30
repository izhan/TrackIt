describe "for amazon api", amazon: true do
  describe "url format" do
    describe "with dp/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/dp/B00CMQTUCE")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00cmqtuce"
        @product.api.should == "amazon"
        #@product.current_price.should == 5400
        @product.name.should == "Kinect Sports: Rivals - Xbox One"
      end
    end

    describe "with name/dp/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/Harry-Potter-Half-Blood-Prince-Book/dp/0439785960/ref=pd_sim_b_2?ie=UTF8&refRID=1FY4BNJTJPS3H75X5D15")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/0439785960"
        @product.api.should == "amazon"
        #@product.current_price.should == 387
        @product.name.should == "Harry Potter and the Half-Blood Prince (Book 6)"
      end
    end

    describe "with gp/product/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/gp/product/B00AW04ZMM/ref=s9_ri_bw_g265_i1?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-8&pf_rd_r=0DHCGWB25QJ6QB57MAS7&pf_rd_t=101&pf_rd_p=1406811242&pf_rd_i=2619525011")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00aw04zmm"
        @product.api.should == "amazon"
        #@product.current_price.should == 16899
        @product.name.should == "Panda Small Compact Portable Washing Machine(6-7lbs Capacity) with Spin Dryer"
      end
    end

    describe "with dp/product/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/dp/product/B00BHE9OX2/ref=sr_1_1?ie=UTF8&qid=1397608306&sr=8-1&keywords=Colgate+Total+75+ml")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00bhe9ox2"
        @product.api.should == "amazon"
        #@product.current_price.should == 394
        @product.name.should == "Colgate Total Pro Gum Health Toothpaste 75ml"
      end
    end

    describe "with gp/product/glance/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/gp/product/glance/B00DDMJ332")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00ddmj332"
        @product.api.should == "amazon"
        #@product.current_price.should == 827
        @product.name.should == "Pampers Sensitive Wipes 12x Pack 744 Count"
      end
    end

    describe "with exec/obidos/asin/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/exec/obidos/asin/B004J3V90Y")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b004j3v90y"
        @product.api.should == "amazon"
        @product.current_price.should == 59900
        @product.name.should == "Canon EOS Rebel T3i 18 MP CMOS Digital SLR Camera and DIGIC 4 Imaging with EF-S 18-55mm f/3.5-5.6 IS Lens"
      end
    end

    describe "for amzn.com urls" do
      before do
        @product = Product.new(url: "amzn.com/B002KAOS60")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b002kaos60"
        @product.api.should == "amazon"
        @product.current_price.should == 361
        @product.name.should == "The Wikipedia Revolution: How a Bunch of Nobodies Created the World's Greatest Encyclopedia"
      end
    end
  end

  describe "item with old/new options" do
    before do
      @product = Product.new(url: "http://www.amazon.com/gp/product/1594633177")
      @product.save
    end

    it "should create correct item" do
      @product.url.should == "amazon.com/dp/1594633177"
      @product.api.should == "amazon"
      #@product.current_price.should == 1660
      @product.name.should == "In Paradise: A Novel"
    end
  end

  describe "with VERY low price" do
    before do
      @product = Product.new(url: "http://www.amazon.com/dp/B00006HTZ0")
      @product.save
    end

    it "should create correct item" do
      @product.url.should == "amazon.com/dp/b00006htz0"
      @product.api.should == "amazon"
      @product.current_price.should == 1
      @product.name.should == "Belkin 8-by-9-Inch Mouse Pad (Black)"
    end
  end

  ## TODO , VERY low price??
  ## TODO creating duplicates?
  # TODO for products with no offers
end