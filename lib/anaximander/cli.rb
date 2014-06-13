module Anaximander
  class CLI
    def self.start
      new(ARGV[0]).start
    end

    def initialize(url)
      @crawler  = Crawler.new(url)
      @renderer = Renderer.new
    end

    def start
      @crawler.crawl
      @renderer.draw(@crawler.root)
    end
  end
end
