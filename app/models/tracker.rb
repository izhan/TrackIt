class Tracker < ActiveRecord::Base
  include ProductTrackerHelper

  attr_accessor :url

  belongs_to :user
  belongs_to :product

  validates_associated :product
  validates_presence_of :product
  validates :url, presence: true
  #validates_format_of :url, :with => VALID_URL_REGEX, message: "Invalid Product URL"

  before_create :add_params

  private
    def add_params
      product = self.product

      self.name = product.name
      self.original_price = product.current_price
      self.alert_price = product.current_price
    end
end
