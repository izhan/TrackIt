require 'spec_helper'

describe "StaticPagesController" do
  describe "for Dashboard" do
    describe "for Best Buy input" do
      subject { page }
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
        visit dashboard_path
      end

      describe "for valid sku number" do
        before do
          sku_number = "5206564"
          fill_in "sku_number", with: sku_number
          click_button "Search"
        end
        it do
          should have_content "Name: Logitech - TV Cam HD"
          should have_content "Price: 199.99"
        end
      end
      describe "for valid url" do
        before do
          url = "http://www.bestbuy.com/site/wireless-adapter/4860965.p?id=1218555765191&skuId=4860965&st=wireless-smart-tv-accessories-112029&cp=1&lp=2"
          fill_in "sku_number", with: url
          click_button "Search"
        end
        it do
          should have_content "Name: Samsung - Wireless Adapter"
          should have_content "Price: 49.99"
        end
      end

      describe "for invalid sku number" do
        before do
          sku_number = "5216564"
          fill_in "sku_number", with: sku_number
          click_button "Search"
        end
        it do
          should_not have_content "Name: "
          should_not have_content "Price: "
        end
      end
      describe "for invalid url" do
        before do
          url = "http://www.amazon.com/"
          fill_in "sku_number", with: url
          click_button "Search"
        end
        it do
          should_not have_content "Name: "
          should_not have_content "Price: "
        end
      end
    end
  end
end
