class TrackersController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.trackers.build(tracker_params)
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