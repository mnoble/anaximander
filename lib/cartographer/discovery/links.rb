module Cartographer
  module Discovery

    # Collection of internal links on the given page. 
    #
    # == Relative Paths
    #
    # `Cartographer::Discovery::Links` converts all relative paths into absolute
    # paths using the base URL of the page being crawled.
    #
    #   # http://example.com
    #   <a href="/contact">Contact</a>
    #
    #   Cartographer::Discovery::Links.new(Nokogiri::HTML(open("http://example.com")))
    #   # => ["http://example.com/contact"]
    #
    # == Exclusions
    #
    #   - External links (ones outside the domain of the page
    #   - Hash links (Javascript style links with href of "#")
    #
    # == Example
    #
    #   page = Nokogiri::HTML(open("http://example.com"))
    #
    #   Cartographer::Discovery::Links.new(page)
    #   # => ["http://www.iana.org/domains/example"]
    #
    class Links
      include Enumerable
      include Comparable
      extend  Forwardable
      def_delegators :links, :size, :inspect, :to_a

      # Parameters
      #
      #   page [Nokogiri::HTML] Parsed html of the page.
      #   url  [String|URI] URL of the page to discover.
      #
      def initialize(page, url)
        @page = page
        @url  = Url.new(url)
      end

      def each(&block)
        links.each(&block)
      end

      def <=>(other)
        to_a <=> other.to_a
      end

      private

      attr_reader :page

      def links
        internal_links.map(&:to_s)
      end

      def internal_links
        all_links.select { |link| @url.base == link.base }
      end

      def all_links
        page.css("a").map { |a| absolute(a[:href]) }.compact.uniq
      end

      def absolute(link)
        Url.new(link).absolute(@url.base).without_fragment
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end
