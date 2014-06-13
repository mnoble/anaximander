module Cartographer
  module Discovery
    class Assets
      include Enumerable
      include Comparable
      extend  Forwardable
      def_delegators :assets, :size, :inspect, :to_a

      def initialize(page)
        @page = page
      end

      def each(&block)
        assets.each(&block)
      end

      def <=>(other)
        to_a <=> other.to_a
      end

      private

      attr_reader :page

      def assets
        css + javascript
      end

      def css
        page.css("link").map { |link| link[:href] }.compact
      end

      def javascript
        page.css("script").map { |script| script[:src] }.compact
      end
    end
  end
end

