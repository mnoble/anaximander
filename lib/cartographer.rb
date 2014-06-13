require "open-uri"
require "nokogiri"
require "forwardable"
require "delegate"
require "uri"
require "logger"

require "cartographer/version"
require "cartographer/url"
require "cartographer/page"
require "cartographer/crawler"
require "cartographer/discovery/links"
require "cartographer/discovery/assets"

module Cartographer
  def self.logger=(out)
    @logger = Logger.new(out)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
