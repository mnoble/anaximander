require "open-uri"
require "nokogiri"
require "forwardable"
require "delegate"
require "uri"
require "logger"

require "anaximander/version"
require "anaximander/url"
require "anaximander/page"
require "anaximander/crawler"
require "anaximander/renderer"
require "anaximander/discovery/links"
require "anaximander/discovery/assets"

module Anaximander
  def self.logger=(out)
    @logger = Logger.new(out)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end
