require "addressable/uri"

module ScraperHelper
  # adds http:// to url if it doesnt have it already
  def add_http_and_clean(url)
    unless url.start_with?('http://') || url.start_with?('https://')
      url = "http://" + url
    end
    url = Addressable::URI.escape(url)
  end
end