class ScraperController < ApplicationController
  include ScraperHelper

  def scraper
  end

  def results
    url = params[:url]
    if url
      @tracker = Tracker.new
      begin
        sanitized_url = add_http_and_clean(url)
        # TODO, add more headers?
        website_file = open(sanitized_url, 
          :allow_redirections => :all
          # "User-Agent" => request.headers['HTTP_USER_AGENT'] # maybe shouldn't use this so we dont have to store user agent
        )

        @page = Nokogiri::HTML(website_file)
        @page.encoding = 'UTF-8'

        root_url = Addressable::URI.parse(sanitized_url).scheme + "://" + Addressable::URI.parse(sanitized_url).host

        # base href tag needed for relative links to work
        base = Nokogiri::XML::Node.new "base", @page
        base['href'] = website_file.base_uri.to_s # not guaranteed to be same as the url param because of url redirection
        @page.at_css('head').children.first.add_previous_sibling(base)
        # TODO maybe this isnt needed...
        # @page.search('body').add_class("scraper-result-body")

        # # getting rid of all relative javascript links
        # @page.css('script').each do |d|
        #   if d.attribute('src')
        #     d['src'] = Addressable::URI.join(root_url, d.attribute('src'))
        #   end
        #   # gets rid of anything that matches "/..." or '/...' but not "//..." or '//...'  Probably not needed....
        #   # d.content = d.content.gsub(/'\/[^\/](.+)'/, '"jcrew.com/\1"').gsub(/"\/[^\/](.+)"/, '"jcrew.com/\1"')
        # end
        # # getting rid of all relative css links
        # @page.css('link').each do |d|
        #   if d.attribute('href')
        #     d['href'] = Addressable::URI.join(root_url, d.attribute('href'))
        #   end
        # end

        # @page.search('//text()').each do |node|
        #   node.content = "YOLO"
        # end

        # prepares for display
        # @page = clean_page(@page)

        #@page.xpath('//*[@id="priceblock-wrapper-wrapper"]/div/div/div[2]')

        # recreate the webpage EXACTLY
        render :layout => false

      rescue => e
        logger.error e.message
        e.backtrace.each { |line| logger.error line }
        flash[:danger] = "Sorry, please try again"
        redirect_to scraper_path
      end
    else
      redirect_to scraper_path
    end
  end

  private
    def clean_page(page)
      # nokogiri adds newlines for some reason.  killing the newlines helps with inline-block items.  on second thought....not a great idea
      page = page.to_s.gsub("\n", "")

      # TODO should also properly handle unicode such as \u0092 => '
    end
end
