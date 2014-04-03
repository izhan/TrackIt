require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  end

  def contact
  end

  def dashboard
    if params[:sku_number] && url = params[:sku_number].match(/(?<sku_number>[[:digit:]]{7}).p/)
      begin
        @bestbuy = JSON.parse(open("http://api.remix.bestbuy.com/v1/products(sku=#{url[:sku_number]})?apiKey=xwfq3c3bekh3u2mnz3yu532f&format=json").read)
        if @bestbuy["total"] == 0
          @bestbuy = nil
          flash[:danger] = "SKU Number Invalid.  Please try again."
        end
      rescue
        flash[:danger] = "BestBuy URL Invalid.  Please try again."
      end
    elsif params[:sku_number] && /[[:digit:]]{7}/.match(params[:sku_number])
      begin
        @bestbuy = JSON.parse(open("http://api.remix.bestbuy.com/v1/products(sku=#{params[:sku_number]})?apiKey=xwfq3c3bekh3u2mnz3yu532f&format=json").read)
        if @bestbuy["total"] == 0
          @bestbuy = nil
          flash[:danger] = "SKU Number Invalid.  Please try again."
        end
      rescue
        puts "HUGE ERROR.  SKU_NUMBER:" # should never reach here
        puts params[:sku_number]
        @bestbuy = nil
        flash[:danger] = "SKU Number Invalid.  Please try again."
      end
    elsif params[:sku_number]
      flash[:danger] = "Please try again."
    end
  end
end
