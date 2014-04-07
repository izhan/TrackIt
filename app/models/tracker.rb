class Tracker < ActiveRecord::Base
  include ProductTrackerHelper

  attr_accessor :url

  belongs_to :user
  belongs_to :product

  validates_associated :product
  validates_presence_of :product
  validates :url, presence: true
  validates_format_of :url, :with => VALID_URL_REGEX, message: "Invalid Product URL"

  before_validation :yolo
  before_create :create_product

  private
    def create_product
      puts "IN CREATE PRODUCT"
      if Product.where(url: self.url).blank?
        puts "need to create new"
        @product = Product.create(url: self.url)
      else
        @product = Product.where(url: self.url).first
      end
      self.product = @product
      puts "YOLO5"
    end
    def yolo
      puts "IN VALIDATION"
    end
    def parse_url
      self.url = clean_url(self.url)

      host = get_host(self.url)

      self.api = get_api(host)

      if self.api == "scrape"
        # only temp.  should scrape the website
        self.current_price = 100000
        self.name = "Temporary Scraping Holder"
        self.thumbnail = "http://i.imgur.com/0y3uACw.jpg"
      # should handle best buy here
      elsif self.api == "bestbuy"
        handle_bestbuy()
      else
        # shouldn't get here
        puts "ERROR UH OH"
        self.current_price = 100000
        self.name = "Temporary Scraping Holder"
        self.thumbnail = "http://i.imgur.com/0y3uACw.jpg"
      end
    end

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
            self.name = bestbuy_json["products"][0]["name"]
            self.current_price = ((bestbuy_json["products"][0]["regularPrice"].to_f)*100).to_int
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

    def get_api(api)
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
