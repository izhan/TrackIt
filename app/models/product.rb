require 'open-uri'
require 'json'

class Product < ActiveRecord::Base
  include ProductTrackerHelper

  validates :url, presence: true
  validates :url, uniqueness: { case_sensitive: false }, on: :create
  validates_format_of :url, :with => VALID_URL_REGEX, message: "Invalid Product URL"

  has_many :trackers, dependent: :destroy
  has_many :users, through: :trackers

  # only needs url as input and generates everything else on the fly
  before_validation :parse_url

  private
    # finds sku number
    BEST_BUY_REGEX = /(\d)+.p$/
    BEST_BUY_API_KEY = "xwfq3c3bekh3u2mnz3yu532f"

    def parse_url
      self.url = clean_url(self.url)

      host = get_host(self.url)

      self.api = categorize_api(host)

      if self.api == "scrape"
        # only temp.  should scrape the website
        self.current_price = 100000
        self.name = "Temporary Scraping Holder"
        self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/0/0f/Cat-eo4jhx8y-100503-500-408_reasonably_small.jpg"
      # should handle best buy here
      elsif self.api == "bestbuy"
        handle_bestbuy()
      else
        # shouldn't get here
        puts "ERROR UH OH"
        self.current_price = 100000
        self.name = "Temporary Error Scraping Holder"
        self.thumbnail = "http://upload.wikimedia.org/wikipedia/commons/0/0f/Cat-eo4jhx8y-100503-500-408_reasonably_small.jpg"
      end
    end

    # sets name, current price and thumbnail img link after call to best buy api
    def handle_bestbuy
      sku_number = self.url[BEST_BUY_REGEX]

      if sku_number
        # gets rid of .p
        sku_number = sku_number[0..-3]
        begin
          bestbuy_json = JSON.parse(open("http://api.remix.bestbuy.com/v1/products(sku=#{sku_number})?apiKey=#{BEST_BUY_API_KEY}&format=json").read)
          if bestbuy_json["total"] == 0
            errors.add(:base, "Best Buy URL Invalid.  Please try again.")
          else
            self.thumbnail = bestbuy_json["products"][0]["thumbnailImage"]
            self.name = bestbuy_json["products"][0]["name"]
            # TODO should get rid of this in favor of decimal column
            self.current_price = Integer(bestbuy_json["products"][0]["regularPrice"].to_s.sub(".", ""))
          end
        rescue
          # for debugging
          puts $!, $@
          errors.add(:base, "Best Buy URL Invalid.  Please try again.")
        end
      else
        errors.add(:base, "Best Buy URL Invalid.  Please try again.")
      end
    end

    def categorize_api(api)
      known_apis = {
        "bestbuy.com" => "bestbuy"
      }
      if known_apis.include?(api)
        return known_apis[api]
      else
        return "scrape"
      end
    end 
end
