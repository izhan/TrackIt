require 'open-uri'
require 'open_uri_redirections'
require 'json'

# TODO moduralize this
BLACKLIST = [
  "chase.com",
  "bankofamerica.com"
]

class StaticPagesController < ApplicationController
  include ProductTrackerHelper
  include ApiHelper
  include DashboardHelper
  before_action :authenticate_user!, only: [:dashboard, :add_alert]

  def home
    if signed_in?
      redirect_to dashboard_path
    end
  end

  # TODO DONT FORGET THERES ANOTHER ONE
  def add_alert
    if params[:url]
      # redirect to scraper if we don't have an api for it
      temp_host = get_host(clean_url(params[:url]))
      if BLACKLIST.include? temp_host
        # TODO could be more customizable messages
        flash[:danger] = "Please Use a Shopping Website."
        redirect_to root_url
        return
      end

      temp_api = categorize_api(temp_host)
      if temp_api == "scrape" && !params[:xpath] && !params[:input_price]
        redirect_to results_path url: params[:url]
        return
      end

      @tracker = current_user.trackers.new(url: params[:url])
      if @tracker.save
        redirect_to edit_tracker_path(@tracker, first_time: true)
      else
        # TODO could be more customizable messages
        flash[:danger] = "Sorry, we are unable to support this website at the time."
        redirect_to root_url
      end
    else
      flash[:danger] = "Sorry, please try using the bookmarklet again."
      redirect_to dashboard_path
    end
  end

  def help
  end

  def contact
  end

  def dashboard
    @tracker = Tracker.new
    @tracker_list = current_user.trackers
  end
end
