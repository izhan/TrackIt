require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  end

  def contact
  end

  def dashboard
    if params[:sku_number]
      begin
        @bestbuy = JSON.parse(open("http://api.remix.bestbuy.com/v1/products(sku=#{params[:sku_number]})?apiKey=xwfq3c3bekh3u2mnz3yu532f&format=json").read)
      rescue
        @bestbuy = {}
        @bestbuy["products"] = [{}]
        @bestbuy["products"][0]["name"] = "SKU Number Invalid"
        @bestbuy["products"][0]["regularPrice"] = "Please Try Again"
      end
    end
  end
end
