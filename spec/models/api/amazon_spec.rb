describe "for amazon api", amazon: true do
  describe "url format" do
    describe "with dp/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/dp/B00006HTZ0")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00006htz0"
        @product.api.should == "amazon"
        @product.current_price.should == 299
        @product.name.should == "Belkin 8-by-9-Inch Mouse Pad (Black)"
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
        @product.current_price.should == 2116
        @product.name.should == "Harry Potter and the Half-Blood Prince (Book 6)"
      end
    end

    describe "with gp/product/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/gp/product/B00AWH595M/ref=fs_clw")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00awh595m"
        @product.api.should == "amazon"
        @product.current_price.should == 11900
        @product.name.should == "Kindle Paperwhite"
      end
    end

    describe "with dp/product/ASIN form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/dp/product/B00BHE9OX2/ref=sr_1_1?ie=UTF8&qid=1397608306&sr=8-1&keywords=Colgate+Total+75+ml")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/b00bhe9Ox2"
        @product.api.should == "amazon"
        @product.current_price.should == 399
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
        @product.current_price.should == 1999
        @product.name.should == "Pampers Sensitive Wipes"
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

  end

  describe "item with old/new options" do
    before do
      @product = Product.new(url: "http://www.amazon.com/gp/product/0439434866/ref=olp_product_details?ie=UTF8&me=&seller=")
      @product.save
    end

    it "should create correct item" do
      @product.url.should == "amazon.com/dp/0439434866"
      @product.api.should == "amazon"
      @product.current_price.should == 5469
      @product.name.should == "Harry Potter Boxset 1-4 (Paperback)"
    end
  end
end