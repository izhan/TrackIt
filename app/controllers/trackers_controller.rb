class TrackersController < ApplicationController
  include ProductTrackerHelper

  before_action :authenticate_user!

  def create
    @tracker = current_user.trackers.build(tracker_params)
    if Product.where(url: clean_url(@tracker.url)).blank?
      @product = Product.create(url: @tracker.url)
    else
      @product = Product.where(url: clean_url(@tracker.url)).first
    end
    @tracker.product = @product
    if @tracker.save
      flash[:success] = "Tracker added!"
      redirect_to root_url
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
      params.require(:tracker).permit(:url)
    end
end
