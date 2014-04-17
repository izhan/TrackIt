module ApiHelper
  # finds sku number
  BEST_BUY_REGEX = /(\d)+\.p/
  # @note gp/product/glance must go before gp/product
  AMAZON_REGEX = /(?:amazon\.com\/(?:gp\/product\/glance|gp\/product|dp\/product|exec\/obidos\/asin|[^\/]+\/dp|dp)\/(?<asin>[^\/]+)|amzn.com\/(?<asin>[^\/]+))/

  # TODO currently does not find bestbuy mobile links
  def find_bestbuy_id(url)
    url[BEST_BUY_REGEX]
  end

  # TODO finish
  def find_amazon_id(url)
    if url.match(AMAZON_REGEX)
      url.match(AMAZON_REGEX)[:asin]
    else
      nil
    end
  end

  def standarize_amazon_url(url)
    asin = find_amazon_id(url)
    "amazon.com/dp/#{asin}"
  end

  def categorize_api(api)
    known_apis = {
      "example.com" => "example",
      "bestbuy.com" => "bestbuy",
      "amzn.com" => "amazon",
      "amazon.com" => "amazon"
    }
    if known_apis.include?(api)
      return known_apis[api]
    else
      return "scrape"
    end
  end 

  # TODO should have a method that appends amazon associate tag
end