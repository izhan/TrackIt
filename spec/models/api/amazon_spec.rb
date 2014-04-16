# BEST BUY
describe "for amazon api" do
  describe "url format" do
    describe "with dp/asin form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/dp/B00006HTZ0")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/B00006HTZ0"
        @product.api.should == "amazon"
        @product.current_price.should == 299
        @product.name.should == "Belkin 8-by-9-Inch Mouse Pad (Black)"
      end
    end

    describe "with name/dp/asin form" do
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

    describe "with gp/product/asin form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/gp/product/B00AWH595M/ref=fs_clw")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/B00AWH595M"
        @product.api.should == "amazon"
        @product.current_price.should == 11900
        @product.name.should == "Kindle Paperwhite"
      end
    end

    describe "with dp/product/asin form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/dp/product/B00BHE9OX2/ref=sr_1_1?ie=UTF8&qid=1397608306&sr=8-1&keywords=Colgate+Total+75+ml")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/B00BHE9OX2"
        @product.api.should == "amazon"
        @product.current_price.should == 399
        @product.name.should == "Colgate Total Pro Gum Health Toothpaste 75ml"
      end
    end

    describe "with gp/product/glance form" do
      before do
        @product = Product.new(url: "http://www.amazon.com/gp/product/glance/B00DDMJ332")
        @product.save
      end

      it "should create correct item" do
        @product.url.should == "amazon.com/dp/B00DDMJ332"
        @product.api.should == "amazon"
        @product.current_price.should == 1999
        @product.name.should == "Pampers Sensitive Wipes"
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