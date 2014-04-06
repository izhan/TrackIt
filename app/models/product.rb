require 'uri'

class Product < ActiveRecord::Base
  include ProductTrackerHelper

  validates :url, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :url, :with => /\A#{URI::regexp}\z/

  has_many :trackers
  has_many :users, through: :trackers

  # only needs url as input and generates everything else on the fly
  before_create :parse_url

  private
    def parse_url
      puts "TEST 1: "
      puts self.url
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
