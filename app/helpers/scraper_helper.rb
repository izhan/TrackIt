module ScraperHelper
  # adds http:// to url if it doesnt have it already
  def add_http(url)
    unless url.start_with?('http://') || url.start_with?('https://')
      url = "http://" + url
    end
    url
  end
end