class Product < ActiveRecord::Base
  validates :url, presence: true
  has_many :trackers
  has_many :users, through: :trackers
end
