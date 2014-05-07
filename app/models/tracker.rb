class Tracker < ActiveRecord::Base
  include ProductTrackerHelper
  include ApiHelper

  ## @note Tracker Class includes -- orginal_price, alert_price, name

  default_scope { order('created_at DESC') }

  attr_accessor :url
  attr_accessor :xpath
  attr_accessor :input_price

  belongs_to :user
  belongs_to :product

  validates_associated :product
  validates_presence_of :product
  #validates :url, presence: true
  #validates_format_of :url, :with => VALID_URL_REGEX, message: "Invalid Product URL"

  before_create :add_params

  before_validation :get_product, on: :create #, :update

  after_destroy :destroy_single_product

  private
    # we get initial parameters from the product
    def add_params
      product = self.product

      self.name = product.name
      self.original_price = product.current_price
      self.alert_price = product.current_price
    end

    def get_product
      # TODO clean this up
      begin
        temp_url = clean_url(self.url)
        host = get_host(temp_url)
        host = categorize_api(host)
        if host == "amazon"
          self.url = standarize_amazon_url(temp_url)
        end
      rescue
        # TODO any error handling here?
      end
      if Product.where(url: clean_url(self.url)).blank?
        some_product = Product.create(url: self.url, xpath: self.xpath, input_price: self.input_price)
      else
        some_product = Product.where(url: clean_url(self.url)).first
      end
      self.product = some_product
    end

    # destroy product if that was the last tracker that used it
    def destroy_single_product
      if self.product.trackers.length == 0
        self.product.destroy
      end
    end
end
