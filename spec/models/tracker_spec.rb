require 'spec_helper'

describe Tracker do
  it { should respond_to(:original_price) }
  it { should respond_to(:alert_price) }
  it { should respond_to(:name) }
  it { should respond_to(:product_id) }
  it { should respond_to(:user_id) }

  describe "creating a new tracker" do
    subject { page }

    before do
      @user1 = FactoryGirl.create(:user)
      sign_in @user1
      visit dashboard_path
    end

    describe "should create a new one with valid input" do
      before do
        fill_in "url", with: "http://www.bestbuy.com/site/custom-classic-toaster-oven-broiler/4957484.p?id=1218583583923&skuId=4957484&st=categoryid$abcat0912022&cp=1&lp=2"
      end

      it "should create a new product" do
        expect { click_button "Add Tracker" }.to change(Product, :count).by(1)
        expect { click_button "Add Tracker" }.to change(Tracker, :count).by(1)
      end

      describe "display the product's info after creation" do
        before do
          click_button "Add Tracker" 
        end
        it do
          should have_content "Cuisinart - Custom Classic Toaster Oven Broiler - Stainless Steel"
          should have_content "79.99"
        end
      end

      it "should not create new products or trackers for same url" do
        before do
          click_button "Add Tracker"
          fill_in "url", with: "http://www.bestbuy.com/site/custom-classic-toaster-oven-broiler/4957484.p?id=1218583583923&skuId=4957484&st=categoryid$abcat0912022&cp=1&lp=2"
        end
        expect { click_button "Add Tracker" }.not_to change(Product, :count)
        expect { click_button "Add Tracker" }.not_to change(Tracker, :count)
      end

      it "should not create new product if one already exists" do
        before do
          @product = Product.new(url: "http://www.bestbuy.com/site/just-dance-2014-nintendo-wii/9638372.p")
        end

        expect { click_button "Add Tracker" }.not_to change(Product, :count)
        expect { click_button "Add Tracker" }.to change(Tracker, :count)
      end
    end
  end

end
