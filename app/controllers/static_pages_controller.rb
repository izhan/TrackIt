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

  # TODO, make sure all "relative" css is replaced with real css

  def scraper
    url = params[:url]
    if url
      begin
        sanitized_url = add_http(url)
        @page = Nokogiri::HTML(open(sanitized_url, :allow_redirections => :all))


        root_url = Addressable::URI.parse(sanitized_url).scheme + "://" + Addressable::URI.parse(sanitized_url).host

        # base href tag needed for relative links to work
        base = Nokogiri::XML::Node.new "base", @page
        base['href'] = root_url
        @page.at_css('head').add_child(base)
        script = Nokogiri::XML::Node.new "script", @page
        script.content = "alert('yo');"
        @page.at_css('head').add_child(script)

        # # getting rid of all relative javascript links
        # @page.css('script').each do |d|
        #   if d.attribute('src')
        #     d['src'] = Addressable::URI.join(root_url, d.attribute('src'))
        #   end
        #   # gets rid of anything that matches "/..." or '/...' but not "//..." or '//...'
        #   d.content = d.content.gsub(/'\/[^\/](.+)'/, '"jcrew.com/\1"').gsub(/"\/[^\/](.+)"/, '"jcrew.com/\1"')
        # end
        # # getting rid of all relative css links
        # @page.css('link').each do |d|
        #   if d.attribute('href')
        #     d['href'] = Addressable::URI.join(root_url, d.attribute('href'))
        #   end
        # end
        # # getting rid of all relative img links
        # @page.css('img').each do |d|
        #   if d.attribute('src')
        #     d['src'] = Addressable::URI.join(root_url, d.attribute('src'))
        #   end
        # end

      rescue
        puts $!, $@
        flash.now[:danger] = "Sorry, please try again"
      end
    end
  end

  def dashboard
    @tracker = Tracker.new
    @tracker_list = current_user.trackers.paginate(page: params[:page])
  end
end
