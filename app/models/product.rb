require 'uri'

class Product < ActiveRecord::Base
  include ProductTrackerHelper

  validates :url, presence: true
  validates :url, uniqueness: { case_sensitive: false }, on: :create
  validates_format_of :url, :with => VALID_URL_REGEX

  has_many :trackers
  has_many :users, through: :trackers

  # only needs url as input and generates everything else on the fly
  before_validation :parse_url

  private
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
      else
        # only temp.  should scrape the website
        self.current_price = 100000
        self.name = "Temporary Scraping Holder"
        self.thumbnail = "http://i.imgur.com/0y3uACw.jpg"
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
