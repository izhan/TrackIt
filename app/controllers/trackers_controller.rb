class TrackersController < ApplicationController
  before_action :authenticate_user!

  def create
    @tracker = current_user.trackers.build(tracker_params)
    if @tracker.save
      flash[:success] = "Tracker added!"
      redirect_to root_url
    else
      puts @tracker.errors.inspect
      puts "poop me"
      render 'static_pages/dashboard'
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