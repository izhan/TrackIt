module ApiHelper
  # finds sku number
  BEST_BUY_REGEX = /(\d)+\.p/
  AMAZON_REGEX = /(\d)+\.p/

  # TODO currently does not find bestbuy mobile links
  def find_bestbuy_id(url)
    url[BEST_BUY_REGEX]
  end

  def find_amazon_id(url)
    "B004J3V90Y"
  end

  def standarize_amazon_url(url)
  end
end