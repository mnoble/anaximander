require "spec_helper"

describe Anaximander::Discovery::Assets do
  let(:html)   { Nokogiri::HTML(open("spec/data/page.html")) }
  let(:assets) { described_class.new(html) }

  # See `spec/data/page.html` for the HTML used in this test.

  it "collects all CSS and Javascript assets" do
    expect(assets.to_a).to eq(["main.css", "other.css", "allthethings.js"])
  end
end
