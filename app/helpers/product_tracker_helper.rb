require 'uri'

module ProductTrackerHelper
  # returns url without params
  def clean_url(url)
    uri = URI(url)
    uri.host + uri.path
  end

  def get_host(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
end
