module Cartographer
  class Error < StandardError; end

  # Raised when a page cannot be fetched.
  #
  class PageNotAccessibleError < Error; end

  # Represents a single page of a website being crawled. Exposes the assets and 
  # links on the page.
  #
  # == Errors
  #
  # `Cartographer::Page` will raise a `PageNotAccessibleError` when the page cannot
  # be fetched for some reason. This is often due to it not existing (404), SSL
  # errors or infinite redirect loops.
  #
  # == Example
  #
  #   page = Page.new("http://example.com")
  #   page.links  # => ["http://www.iana.org/domains/example"]
  #   page.assets # => ["/main.css", "/default.js"]
  #
  class Page
    include Comparable

    # Absolute url of the page.
    #
    attr_reader :url

    # Parsed Nokogiri HTML document.
    #
    attr_reader :html

    # Collection of `Page` objects that are linked 
    # to from the current page.
    #
    attr_accessor :children

    # Parameters
    #
    #   [String] url URL to discover.
    #
    # OpenURI raises a generic RuntimeError when it cannot fetch a
    # page, for a variety of reasons. Some of which are 404s, SSL
    # errors, or redirect loops.
    #
    # raises `PageNotAccessibleError` when OpenURI fails to fetch the
    # page, for any reason.
    #
    def initialize(url)
      @url  = url
      @html = Nokogiri::HTML(open(url))
    rescue RuntimeError, OpenURI::HTTPError
      raise PageNotAccessibleError
    end

    def links
      Discovery::Links.new(html, url)
    end

    def assets
      Discovery::Assets.new(html)
    end

    def <=>(other)
      self.url <=> other.url
    end

    def inspect
      %(#<Cartographer::Page:#{object_id} url="#{url}">)
    end
  end
end
