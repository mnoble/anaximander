require "spec_helper"

describe Cartographer::Page do
  let(:html) { File.read(File.expand_path("../../data/page.html", __FILE__)) }
  let(:page) { described_class.new("http://example.com") }

  before do
    expect_any_instance_of(described_class).to receive(:open).and_return(html)
  end

  it "has unique links" do
    expect(Cartographer::Discovery::Links).to receive(:new).with(an_instance_of(Nokogiri::HTML::Document), "http://example.com")
    page.links
  end

  it "has assets" do
    expect(Cartographer::Discovery::Assets).to receive(:new).with(an_instance_of(Nokogiri::HTML::Document))
    page.assets
  end

  it "is comparable by URL" do
    expect(page).to eq(page.clone)
  end
end
