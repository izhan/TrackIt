require 'open-uri'
require 'open_uri_redirections'
require 'json'

class StaticPagesController < ApplicationController
  include DashboardHelper
  before_action :authenticate_user!, only: [:dashboard]

  def home
    puts "poop"
    puts request.headers['HTTP_USER_AGENT']
    puts request.headers.inspect
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
        website_file = open(sanitized_url, 
          :allow_redirections => :all,
          "User-Agent" => request.headers['HTTP_USER_AGENT']
        )
        @page = Nokogiri::HTML(website_file)

        root_url = Addressable::URI.parse(sanitized_url).scheme + "://" + Addressable::URI.parse(sanitized_url).host

        # base href tag needed for relative links to work
        base = Nokogiri::XML::Node.new "base", @page
        base['href'] = website_file.base_uri.to_s # not guaranteed to be same as the url param because of url redirection
        @page.at_css('head').add_child(base)

        # getting rid of all relative javascript links
        @page.css('script').each do |d|
          if d.attribute('src')
            d['src'] = Addressable::URI.join(root_url, d.attribute('src'))
          end
          # gets rid of anything that matches "/..." or '/...' but not "//..." or '//...'  Probably not needed....
          # d.content = d.content.gsub(/'\/[^\/](.+)'/, '"jcrew.com/\1"').gsub(/"\/[^\/](.+)"/, '"jcrew.com/\1"')
        end
        # getting rid of all relative css links
        @page.css('link').each do |d|
          if d.attribute('href')
            d['href'] = Addressable::URI.join(root_url, d.attribute('href'))
          end
        end

      rescue
        puts $!, $@
        flash.now[:danger] = "Sorry, please try again"
      end
    end

    # recreate
    render :layout => false
  end

  def dashboard
    @tracker = Tracker.new
    @tracker_list = current_user.trackers.paginate(page: params[:page])
  end
end
