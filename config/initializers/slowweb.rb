if Rails.env == 'test'
  require 'slowweb'
  SlowWeb.limit('api.remix.bestbuy.com', 4, 1)
end

