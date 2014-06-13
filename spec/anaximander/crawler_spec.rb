require "spec_helper"

describe Anaximander::Crawler do
  let(:link)        { "http://example.com" }
  subject!(:crawler) { described_class.new(link) }

  it "does not visit pages that have already been visited" do
    crawler.visit(link)
    expect(crawler.visit(link)).to be_nil
  end

  it "does not visit pages that do not exist" do
    not_a_page = "http://example.com/definitelynotapage"
    expect(crawler.visit(not_a_page)).to be_nil
  end

  it "visits links breadth-first" do
    allow_any_instance_of(Anaximander::Page).to receive(:open).and_return("")

    root     = Anaximander::Page.new("http://example.com")
    pricing  = Anaximander::Page.new("http://example.com/pricing")
    features = Anaximander::Page.new("http://example.com/features")

    allow(Anaximander::Page).to receive(:new).with("http://example.com/pricing").and_return(pricing)
    allow(Anaximander::Page).to receive(:new).with("http://example.com/features").and_return(features)

    allow(root).to receive_messages(links: ["http://example.com/pricing", "http://example.com/features"])
    allow(pricing).to receive_messages(links: ["http://example.com/features"])

    crawler.crawl(root)
    expect(root.children).to eq [pricing, features]
  end

  it "crawls a multi-tiered website", :endtoend do
    # See `spec/data/site` for the website hierarchy; it matches
    # the directory structure.

    crawler = described_class.new("http://localhost:#{@port}/index.html")
    crawler.crawl

    root = crawler.root

    pricing = root.children[0]
    features = root.children[1]

    pricing_low = pricing.children[0]
    pricing_med = pricing.children[1]
    pricing_high = pricing.children[2]

    sortof_high = pricing_high.children[0]
    super_high = pricing_high.children[1]

    expect(root.children.size).to eq 2
    expect(root.children).to eq [pricing, features]

    expect(pricing.children.size).to eq 3
    expect(pricing.children).to eq [pricing_low, pricing_med, pricing_high]

    expect(pricing_high.children.size).to eq 2
    expect(pricing_high.children).to eq [sortof_high, super_high]

    expect(features.children.size).to eq 0
  end
end
