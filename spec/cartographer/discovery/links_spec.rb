require "spec_helper"

describe Cartographer::Discovery::Links do
  let(:html)  { Nokogiri::HTML(open("spec/data/page.html")) }
  let(:links) { described_class.new(html, "http://example.com/") }

  # See `spec/data/page.html` for the HTML used in this test.

  it "collects each unique link" do
    expect(links.size).to eq(2)
  end

  it "only collects links within the same domain" do
    expect(links).to_not include "http://example.net"
  end

  it "removes trailing slashes from URLs" do
    expect(links).to_not include "http://example.com/"
  end

  it "disgards hash links" do
    links.each { |link| expect(link).to_not include "#" }
  end

  it "expands relative paths to absolute paths" do
    expect(links).to include "http://example.com/google"
  end

  it "expands relative paths to absolute paths using the base url of the page" do
    links = described_class.new(html, "http://example.com/some/nested/page/")
    expect(links).to_not include "http://example.com/some/nested/page/google"
  end
end
