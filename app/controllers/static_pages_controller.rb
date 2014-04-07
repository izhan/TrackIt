require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
    if signed_in?
      redirect_to dashboard_path
    end
  end

  def contact
  end

  def dashboard
    @tracker = Tracker.new
    @tracker_list = current_user.trackers.paginate(page: params[:page])
  end

  private

    def bestbuy_api?(url)
      url.match(/(?<sku_number>[[:digit:]]{7}).p/)
    end
end
