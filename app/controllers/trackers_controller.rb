class TrackersController < ApplicationController
  before_action :authenticate_user!

  def create
    @tracker = current_user.trackers.build(tracker_params)
    if Product.where(url: @tracker.url).blank?
      @product = Product.create(url: @tracker.url)
    else
      @product = Product.where(url: @tracker.url).first
      @product.save
    end
    @tracker.product = @product
    if @tracker.save
      flash[:success] = "Tracker added!"
      redirect_to root_url
    else
      # could be more customizable messages
      flash[:danger] = "Invalid URL"
      redirect_to root_url
    end
  end

  def destory
    @tracker.destroy
    redirect_to dashboard_url
  end

  private

    def tracker_params
      params.require(:tracker).permit(:url)
    end
end