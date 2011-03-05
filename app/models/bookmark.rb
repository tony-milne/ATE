require "net/http"
class Bookmark < ActiveRecord::Base
  belongs_to :site
  
  validates_presence_of :url
  validate :is_valid_url
  validates_uniqueness_of :url

  before_create :link_to_site

  private

  def link_to_site
    url = fetch_url(self.url)
    host = extract_host(url)
    self.site = Site.find_or_create_by_url(host)
  end

  def extract_host(url)
    url_arr = URI::split(url)
    return url_arr[2]
  end

  #Adapted code from http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/index.html
  def fetch_url(url, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0
    
    response = Net::HTTP.get_response(URI.parse(url))
    case response
    when Net::HTTPSuccess     then url
    when Net::HTTPRedirection then fetch_url(response['location'], limit - 1)
    else
      response.error!
    end
  end

  def is_valid_url
    begin
      res = Net::HTTP.get_response(URI.parse(self.url))
    rescue Errno::ECONNREFUSED
      if errors[:url].nil?
        s = "entered is invalid.  Either the site was unreachable or the "
        s += "URL was entered incorrectly."
        errors.add(:url, s)
      end
    rescue URI::InvalidURIError
      s = "entered is invalid."
      errors.add(:url, s)
    rescue SocketError
      s = "entered is invalid."
      errors.add(:url, s)
    end
  end
end
