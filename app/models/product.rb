require 'open-uri'
require 'json'
require 'amazon/ecs'

class Product < ActiveRecord::Base
  include ProductTrackerHelper
  include ApiHelper
  include ScraperHelper

  attr_accessor :input_price

  validates :thumbnail, presence: true # not sure if we need to validate thumbnail
  validates :api, presence: true
  validates :name, presence: true
  validates :current_price, presence: true
  validates :url, presence: true
  validates :url, uniqueness: { case_sensitive: false }, on: :create
  validates_format_of :url, :with => VALID_URL_REGEX, message: "Invalid Product URL"

  has_many :trackers, dependent: :destroy
  has_many :users, through: :trackers

  # only needs url as input and generates everything else on the fly
  before_validation :process_url, on: :create #, :update


  def update_details
    if self.api == "scrape"
      handle_scrape()
    # handle known urls here
  elsif self.api == "bestbuy"
    handle_bestbuy()
  elsif self.api == "amazon"
    handle_amazon()
  elsif self.api == "example"
    handle_example()
  else
    # shouldn't get here
    logger.debug "ERROR UH OH"
    self.current_price = 100000
    self.name = "Fatal Error Scraping Holder"
    self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/f/f3/No_image_placeholder.gif"
  end
end

private
BEST_BUY_API_KEY = "xwfq3c3bekh3u2mnz3yu532f"

def process_url
  self.url = clean_url(self.url)
  host = get_host(self.url)

  self.api = categorize_api(host)

  if self.api == "scrape"
    handle_scrape()
      # handle known urls here
    elsif self.api == "bestbuy"
      handle_bestbuy()
    elsif self.api == "amazon"
      handle_amazon()
    elsif self.api == "example"
      handle_example()
    else
        # shouldn't get here
        logger.debug "ERROR UH OH"
        self.current_price = 100000
        self.name = "Temporary Error Scraping Holder"
        self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/f/f3/No_image_placeholder.gif"
      end
    end

    # sets name, current price and thumbnail img link after call to best buy api
    def handle_bestbuy
      sku_number = find_bestbuy_id(self.url)

      if sku_number
        # gets rid of .p
        sku_number = sku_number[0..-3]
        begin
          bestbuy_json = JSON.parse(open("http://api.remix.bestbuy.com/v1/products(sku=#{sku_number})?apiKey=#{BEST_BUY_API_KEY}&format=json").read)
          if bestbuy_json["total"] == 0
            errors.add(:base, "Best Buy URL Invalid.  Please try again.")
          else
            self.thumbnail = bestbuy_json["products"][0]["largeImage"] || bestbuy_json["products"][0]["image"] 
            self.name = bestbuy_json["products"][0]["name"]
            # TODO should get rid of this in favor of decimal column
            self.current_price = Integer(bestbuy_json["products"][0]["salePrice"].to_s.sub(".", "")) || Integer(bestbuy_json["products"][0]["regularPrice"].to_s.sub(".", ""))
          end
        rescue => e
          # for debugging
          logger.error e.message
          e.backtrace.each { |line| logger.error line }
          errors.add(:base, "Best Buy URL Invalid.  Please try again.")
        end
      else
        errors.add(:base, "Best Buy URL Invalid.  Please try again.")
      end
    end

    # @note use http://associates-amazon.s3.amazonaws.com/scratchpad/index.html to look for params
    # TODO check differences between new vs old
    def handle_amazon
      asin = find_amazon_id(self.url)
      if asin
        amzn_request = Amazon::Ecs.item_lookup(asin, :response_group => 'Images,ItemAttributes,Offers')
        if amzn_request.is_valid_request? && !amzn_request.has_error?
          result = amzn_request.first_item
          self.name = result.get('ItemAttributes/Title')
          self.thumbnail = result.get('LargeImage/URL') || result.get('MediumImage/URL')
          # sometimes, it defaults to too low price
          self.current_price = result.get('OfferSummary/LowestNewPrice/Amount') || 1
          self.url = standarize_amazon_url(self.url)
        else
          errors.add(:base, "Amazon URL Invalid.  Please try again.")
        end
      else
        errors.add(:base, "Amazon URL Invalid.  Please try again.")
      end
    end

    def handle_example
      if !self.name
        self.name = self.url
        self.current_price = 100
        self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/f/f3/No_image_placeholder.gif"
      end
    end

    def handle_scrape
      # should follow exactly the results page
      begin
        sanitized_url = add_http_and_clean(self.url)
        # TODO, add more headers?
        website_file = open(sanitized_url, 
          :allow_redirections => :all
          )

        @page = Nokogiri::HTML(website_file)
        @page.encoding = 'UTF-8'

        # for now, dont worry about javascript execution
        xpath_price = @page.xpath(self.xpath)
        # get rid of everything else
        # reminder: js regex is /^((sale|saleprice|price|US|USD)(:|-)?)?\$?(\d+(,\d{3})*(\.\d{2})?)?$/i
        # also removes all commas and whitespace
        xpath_price = xpath_price.text
        if !xpath_price.include?(".")
          xpath_price = xpath_price + ".00"
        end
        xpath_price = xpath_price.gsub(/\s+/, "").gsub(/(sale)/i, "").gsub(/(price)/i, "").gsub(/(US)/i, "").gsub(/(USD)/i, "").gsub(":", "").gsub("-", "").gsub(",", "").gsub(".", "").gsub("$", "")
        
        # on first creation
        if self.input_price 
          if xpath_price == self.input_price
            self.current_price = xpath_price
            self.name = "Scraped: " + self.url
            self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/f/f3/No_image_placeholder.gif"
          else
            logger.debug "prices didn't match"
            logger.debug "expected: " + self.input_price
            logger.debug "got: " + xpath_price
            errors.add(:base, "Sorry, we could not complete your request.  Please try again.")
          end
        else
          self.current_price = xpath_price
          self.name = "Scraped: " + self.url
          self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/f/f3/No_image_placeholder.gif"
        end
      rescue => e
        logger.error "nokogiri scraping failed"
        logger.error e.message
        e.backtrace.each { |line| logger.error line }
        errors.add(:base, "Sorry, we could not complete your request.  Please try again.")
      end
    end
  end
