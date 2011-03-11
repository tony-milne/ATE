require "net/http"
require "open-uri"
include Search

class Bookmark < ActiveRecord::Base
  belongs_to :site
  
  validates_presence_of :url
  validate :is_valid_url
  validates_uniqueness_of :url

  before_save :adjust_for_redirect

  before_save :get_page
  before_save :get_page_title
  before_save :get_content_type
  before_save :get_description

  before_save :get_shortened_url

  before_create :link_to_site

  private

  # Callback to check url entered by user is valid.  Catches timeouts,
  # invalid URIs and addresses that don't exist
  def is_valid_url
    begin
      resolved_url = fetch_url(self.url)
      raise Exception if(Bookmark.find_by_url(resolved_url))
    rescue URI::InvalidURIError
      s = "entered is invalid."
      errors.add(:url, s)
    rescue Exception
      s = "is unreachable."
      errors.add(:url, s)
    end
  end

  # Validates url for uniqueness after adjust_for_redirect is called
  def validate_unique
    Rails.logger.debug self.url
    if Bookmark.find_by_url(self.url)
      s = "is not unique"
      errors.add(:url, s)
    end
  end

  # Follows any redirects and adjusts the user's input
  def adjust_for_redirect
    self.url = fetch_url(self.url)
  end

  # Callback to create association between a bookmark and the site it comes from
  def link_to_site
    host = extract_host(url)
    self.site = Site.find_or_create_by_url(host)
  end

  def get_page
    @doc = Nokogiri::HTML(open("#{self.url}"))
  end

  # Adds page title to bookmark record
  def get_page_title
    if !(@doc.at_css("title").nil?)
      title = @doc.at_css "title"
      self.page_title = title.content
    end
  end

  # Adds content type to bookmark record
  def get_content_type
    if !(@doc.at_css("meta[http-equiv='Content-Type']").nil?)
      content_type = @doc.at_css("meta[http-equiv='Content-Type']")["content"]
      self.meta_content_type = content_type
    end
  end

  # Adds page description to bookmark record
  def get_description
    if !(@doc.at_css("meta[name='description']").nil?)
      description = @doc.at_css("meta[name='description']")["content"]
      self.meta_description = description
    end
  end

  # Uses url to get tinyurl shortened url and adds it bookmark record
  def get_shortened_url
    begin
      short_url = Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=#{self.url}"))
      self.shortened_url = short_url
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

      # Tries adding trailing slash to url
      if !url.match(/\/$/)
        url = url << "/"
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
