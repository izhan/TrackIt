BLACKLIST = [
  "chase.com",
  "bankofamerica.com"
]

class TrackersController < ApplicationController
  include ProductTrackerHelper
  include ApiHelper

  before_action :authenticate_user!

  # current user assigned by current_user method
  def edit
    @tracker = Tracker.find(params[:id])
  end

  def update
    @tracker = Tracker.find(params[:id])
    puts "YOLO"
    puts params[:alert_price]
    puts params[:name]
    puts tracker_params
    puts tracker_params.inspect
    if @tracker.update_attributes(tracker_params)
      if params[:first_time]
        flash[:success] = "Alert Added!"
      else
        flash[:success] = "Alert Updated!"
      end
      redirect_to dashboard_url
    else
      render 'edit'
    end
  end

  def create
    # redirect to scraper if we don't have an api for it
    temp_host = get_host(clean_url(tracker_params[:url]))
    if BLACKLIST.include? temp_host
      # TODO could be more customizable messages
      flash[:danger] = "Please Use a Shopping Website."
      redirect_to root_url
      return
    end

    temp_api = categorize_api(temp_host)
    if temp_api == "scrape" && !tracker_params[:xpath] && !tracker_params[:input_price]
      redirect_to results_path url: tracker_params[:url]
      return
    end

    @tracker = current_user.trackers.new(tracker_params)
    if @tracker.save
      redirect_to edit_tracker_path(@tracker, first_time: true)
    else
      # TODO could be more customizable messages
      flash[:danger] = "Invalid URL"
      redirect_to root_url
    end
  end

  def destroy
    @tracker = Tracker.find(params[:id])
    @tracker.destroy
    redirect_to dashboard_url
    flash[:success] = "Tracker deleted!"
  end

  private

    def tracker_params
      params.require(:tracker).permit(:url, :xpath, :input_price, :name, :alert_price) # TODO security flaw?
    end
end
