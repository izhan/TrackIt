if Rails.env == 'test'
  require 'slowweb'
  SlowWeb.limit('api.remix.bestbuy.com', 4, 1)
  SlowWeb.limit('webservices.amazon.com', 1, 1)
end

