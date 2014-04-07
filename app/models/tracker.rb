class Tracker < ActiveRecord::Base
  attr_accessor :url
  
  belongs_to :user
  belongs_to :product
end
