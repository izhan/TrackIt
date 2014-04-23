require 'spec_helper'

describe Tracker do
  it { should respond_to(:original_price) }
  it { should respond_to(:alert_price) }
  it { should respond_to(:name) }
  it { should respond_to(:product_id) }
  it { should respond_to(:user_id) }

  describe "creating a new tracker", api: true, bestbuy: true, focus: true do
    subject { page }

    before do
      @user1 = FactoryGirl.create(:user)
      sign_in @user1
      visit dashboard_path
    end

    describe "for blank url" do
      before do
        fill_in "Url", with: ""
      end

      it "should not change tracker count" do
        expect { click_button "start tracking" }.to_not change(Tracker, :count).by(1)
      end
    end

    describe "for invalid input for best buy" do
      before do
        fill_in "Url", with: "http://www.bestbuy.com/asdf123"
      end

      it "should not change tracker count" do
        expect { click_button "start tracking" }.to_not change(Tracker, :count).by(1)
      end
      it "should not change user's tracker's count" do
        expect { click_button "start tracking" }.to_not change(@user1.trackers, :count).by(1)
      end
      it "should not change product count" do
        expect { click_button "start tracking" }.to_not change(Product, :count).by(1)
      end
    end

    describe "should create a new one with valid input" do
      before do
        fill_in "Url", with: "http://www.bestbuy.com/site/custom-classic-toaster-oven-broiler/4957484.p?id=1218583583923&skuId=4957484&st=categoryid$abcat0912022&cp=1&lp=2"
      end

      it "should create a new product" do
        expect { click_button "start tracking" }.to change(Product, :count).by(1)
      end
      it "should create a new product" do
        expect { click_button "start tracking" }.to change(Tracker, :count).by(1)
      end

      describe "display the product's info after creation" do
        before do
          click_button "start tracking" 
        end
        it do
          should have_content "Cuisinart - Custom Classic Toaster Oven Broiler - Stainless Steel"
          should have_content "79.99"
        end
      end

      describe "for same url" do
        before do
          click_button "start tracking"
          fill_in "Url", with: "http://www.bestbuy.com/site/custom-classic-toaster-oven-broiler/4957484.p?id=1218583583923&skuId=4957484&st=categoryid$abcat0912022&cp=1&lp=2"
        end
        it "should not create new products or trackers" do
          expect { click_button "start tracking" }.not_to change(Product, :count)
        end
      end

      describe "and if one already exists" do
        before do
          @product = Product.new(url: "http://www.bestbuy.com/site/custom-classic-toaster-oven-broiler/4957484.p?id=12185835")
          @product.save
        end
        it "should not create new product" do
          expect { click_button "start tracking" }.not_to change(Product, :count)
        end
      end
    end
  end

  # NO capybara here
  describe "when deleting a tracker" do

    describe "if there is only one tracker with that product" do
      before do
        @tracker = Tracker.create(url: "http://www.bestbuy.com/site/rocketfish-6-in-wall-hdmi-cable/2634897.p?id=1218343205770&skuId=2634897")
      end

      it "should also delete product when tracker is deleted" do
        expect { @tracker.destroy }.to change(Product, :count).by(-1)
      end
    end

    describe "if there is two or more trackers with that product" do
      before do
        @tracker = Tracker.create(url: "http://www.bestbuy.com/site/rocketfish-6-in-wall-hdmi-cable/2634897.p?id=1218343205770&skuId=2634897")
        @tracker2 = Tracker.create(url: "http://www.bestbuy.com/site/rocketfish-6-in-wall-hdmi-cable/2634897.p?id=1218343205770&skuId=2634897")
      end

      it "should also delete product when tracker is deleted" do
        expect { @tracker.destroy }.to_not change(Product, :count)
      end
    end
  end

end
