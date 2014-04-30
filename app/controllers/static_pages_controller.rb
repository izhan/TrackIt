require 'open-uri'
require 'open_uri_redirections'
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

  def dashboard
    @tracker = Tracker.new
    @tracker_list = current_user.trackers.paginate(page: params[:page])
    @tracker.url = params[:tracker_url] || ""
  end
end
