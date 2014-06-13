module Cartographer
  class Url < SimpleDelegator
    include Comparable

    attr_reader :uri

    def initialize(uri)
      @uri = URI(uri.to_s)
      super(@uri)
    end

    def base
      domain  = "#{scheme}://#{host}"
      domain += ":#{port}" unless port == 80
      domain
    end

    def join(url)
      self.class.new(URI.join(self.uri, url.to_s))
    end

    def absolute(base)
      absolute? ? self : Url.new(base).join(self)
    end

    def without_fragment
      self.class.new(self).tap { |url| url.fragment = nil }
    end

    def <=>(other)
      other.respond_to?(:uri) ? self.uri <=> other.uri : self.uri.to_s <=> other
    end

    def eql?(other)
      self.uri.eql?(other.uri)
    end
  end
end
