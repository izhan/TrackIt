module ApiHelper
  # finds sku number
  BEST_BUY_REGEX = /(\d)+\.p/

  def find_bestbuy_url(url)
    url[BEST_BUY_REGEX]
  end

  def find_amazon_url(url)
  end
end