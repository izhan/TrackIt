require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  end

  def contact
  end

  def dashboard
    @bestbuy = JSON.parse(open("http://api.remix.bestbuy.com/v1/products(sku=5430505)?apiKey=xwfq3c3bekh3u2mnz3yu532f&format=json").read)
    puts @bestbuy
  end
end
