require "spec_helper"

describe Cartographer::Url do
  it "exposes the scheme and host as base" do
    base = described_class.new("http://example.com/foo/bar?baz=1").base
    expect(base).to eq "http://example.com"
  end

  it "joins other Urls" do
    url = described_class.new("http://example.com").join(described_class.new("/foo"))
    expect(url).to eq described_class.new("http://example.com/foo")
  end

  it "joins with a String url" do
    url = described_class.new("http://example.com").join("/foo")
    expect(url).to eq described_class.new("http://example.com/foo")
  end

  it "creates the absolute path when representing a relative path" do
    url = described_class.new("/foo")
    expect(url.absolute("http://example.com")).to eq described_class.new("http://example.com/foo")
  end

  it "does not create the absolute path if already representing one" do
    url = described_class.new("http://example.com/foo")
    expect(url.absolute("http://example.net")).to eq described_class.new("http://example.com/foo")
  end

  it "removes the fragment" do
    url = described_class.new("http://example.com/#one-page-app")
    expect(url.without_fragment).to eq described_class.new("http://example.com/")
  end

  it "is comparable to other Urls" do
    url1 = described_class.new("http://example.com")
    url2 = described_class.new("http://example.com")
    expect(url1).to eq(url2)
  end

  it "is comparable to a string URL" do
    url1 = described_class.new("http://example.com")
    url2 = "http://example.com"
    expect(url1 == url2).to eq true
  end
end
