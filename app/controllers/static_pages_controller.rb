require 'open-uri'
require 'json'

class StaticPagesController < ApplicationController
  include DashboardHelper
  before_action :authenticate_user!, only: [:dashboard]

  def home
    if signed_in?
      redirect_to dashboard_path
    end
  end

  def contact
  end

  def scraper
    url = params[:url]
    if url
      begin
        @page = Nokogiri::HTML(open(add_http(url)))
      rescue
        flash.now[:danger] = "Sorry, please try again"
      end
    end
  end

  def dashboard
    @tracker = Tracker.new
    @tracker_list = current_user.trackers.paginate(page: params[:page])
  end
end
