require "net/http"
class Bookmark < ActiveRecord::Base
  belongs_to :site
  
  validates_presence_of :url
  validate :is_valid_url
  validates_uniqueness_of :url

  before_save :adjust_for_redirect
  before_create :link_to_site

  private

  # Follows any redirects and adjusts the user's input
  def adjust_for_redirect
    self.url = fetch_url(self.url)
  end

  # Callback to create association between a bookmark and the site it comes from
  def link_to_site
    host = extract_host(url)
    self.site = Site.find_or_create_by_url(host)
  end

  # Callback to check url entered by user is valid.  Catches timeouts,
  # invalid URIs and addresses that don't exist
  def is_valid_url
    begin    
      fetch_url(self.url)
    rescue Errno::ECONNREFUSED
      s = "entered is invalid.  Either the site was unreachable or the "
      s += "URL was entered incorrectly."
      errors.add(:url, s)
    rescue URI::InvalidURIError
      s = "entered is invalid."
      errors.add(:url, s)
    rescue SocketError
      s = "entered is invalid."
      errors.add(:url, s)
    end
  end



  # Given a url, returns the host portion of the url
  def extract_host(url)
    url_arr = URI::split(url)
    return url_arr[2]
  end

  # Adapted code from http://www.ruby-doc.org/stdlib/libdoc/net/http/rdoc/index.html
  # Given a url, it follows any redirects (within a certain limit), returning
  # the url or an error
  def fetch_url(url, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    if url
      # Tries adding http:// to beginning of url
      if !url.match(/^http:\/\/(.*)/)
        url = "http://" + url
      end
    end
  
    response = Net::HTTP.get_response(URI.parse(url))
    case response
    when Net::HTTPSuccess     then url
    when Net::HTTPRedirection then fetch_url(response['location'], limit - 1)
    else
      response.error!
    end
  end
end
