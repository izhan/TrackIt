if Rails.env == 'test'
  require 'slowweb'
  SlowWeb.limit('api.remix.bestbuy.com', 5, 1)
end

