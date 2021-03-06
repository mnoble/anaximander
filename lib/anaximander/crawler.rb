module Anaximander
  class Crawler
    attr_reader :url, :root

    def initialize(url)
      @url = url.chomp("/")
      @root = Page.new(url)
      @visited = [url]
    end

    def crawl(page=self.root)
      page.children = page.links.map { |link| visit(link.chomp("/")) }.compact
      page.children.each { |child| crawl(child) }
    end

    def visit(link)
      return if @visited.include?(link)

      logger.debug(link)
      @visited << link

      Page.new(link)
    rescue Anaximander::PageNotAccessibleError
      nil
    end

    def logger
      Anaximander.logger
    end
  end
end
